import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/city_provider.dart';
import '../services/weather_service.dart';
import '../services/ai_service.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/error_view.dart';

class TravelInfoScreen extends StatefulWidget {
  const TravelInfoScreen({super.key});

  @override
  State<TravelInfoScreen> createState() => _TravelInfoScreenState();
}

class _TravelInfoScreenState extends State<TravelInfoScreen> with SingleTickerProviderStateMixin {
  final WeatherService _weatherService = WeatherService();
  final AIService _aiService = AIService();
  Map<String, dynamic> _weatherData = {};
  String _aiTip = '';
  bool _isLoading = true;
  String? _error;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final city = context.read<CityProvider>().selectedCity;
      if (city != null) {
        final weatherData = await _weatherService.getWeather(city.name);
        final aiTip = await _aiService.getTravelTip(city.name);
        
        if (mounted) {
          setState(() {
            _weatherData = weatherData;
            _aiTip = aiTip;
            _isLoading = false;
          });
          _controller.forward();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load data. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final city = context.watch<CityProvider>().selectedCity;
    if (city == null) {
      return const Scaffold(
        body: Center(
          child: Text('No city selected'),
        ),
      );
    }

    return Scaffold(
      body: _isLoading
          ? _buildLoadingState()
          : _error != null
              ? ErrorView(
                  message: _error!,
                  onRetry: _loadData,
                )
              : CustomScrollView(
                  slivers: [
                    _buildAppBar(city),
                    _buildContent(city),
                  ],
                ),
    );
  }

  Widget _buildLoadingState() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('Loading...'),
            background: ShimmerLoading(
              width: double.infinity,
              height: 300,
              borderRadius: 0,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ShimmerLoading(
                  width: double.infinity,
                  height: 100,
                ),
                const SizedBox(height: 16),
                ShimmerLoading(
                  width: double.infinity,
                  height: 200,
                ),
                const SizedBox(height: 16),
                ShimmerLoading(
                  width: double.infinity,
                  height: 150,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(City city) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          city.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 3.0,
                color: Colors.black,
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'city_${city.name}',
              child: CachedNetworkImage(
                imageUrl: city.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const ShimmerLoading(
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: 0,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black54,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(City city) {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWeatherSection(),
              _buildAttractionsSection(city),
              _buildCuisineSection(city),
              _buildAITipsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherSection() {
    return _buildSection(
      'Weather',
      Icons.wb_sunny,
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_weatherData['temperature']}°C',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  _getWeatherIcon(_weatherData['description']),
                  size: 48,
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _weatherData['description'],
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildWeatherInfo('Humidity', '${_weatherData['humidity']}%'),
                _buildWeatherInfo('Wind', '${_weatherData['windSpeed']} m/s'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String description) {
    description = description.toLowerCase();
    if (description.contains('rain')) return Icons.grain;
    if (description.contains('cloud')) return Icons.cloud;
    if (description.contains('sun')) return Icons.wb_sunny;
    if (description.contains('snow')) return Icons.ac_unit;
    if (description.contains('thunder')) return Icons.flash_on;
    return Icons.wb_sunny;
  }

  Widget _buildAttractionsSection(City city) {
    return _buildSection(
      'Popular Attractions',
      Icons.place,
      Column(
        children: city.attractions.map((attraction) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.star, color: Colors.amber),
              title: Text(attraction),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Implement attraction details
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Coming soon: $attraction details'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCuisineSection(City city) {
    return _buildSection(
      'Local Cuisine',
      Icons.restaurant,
      Column(
        children: city.cuisine.map((dish) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.restaurant_menu, color: Colors.red),
              title: Text(dish),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Implement cuisine details
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Coming soon: $dish details'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAITipsSection() {
    return _buildSection(
      'AI Travel Tips',
      Icons.lightbulb,
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.lightbulb, color: Colors.amber, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _aiTip,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, IconData icon, Widget content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }
} 