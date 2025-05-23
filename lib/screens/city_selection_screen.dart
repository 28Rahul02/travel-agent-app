import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/city_provider.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/error_view.dart';
import 'travel_info_screen.dart';

class CitySelectionScreen extends StatefulWidget {
  const CitySelectionScreen({super.key});

  @override
  State<CitySelectionScreen> createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _isLoading = true;
  String? _error;

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
      // Simulate loading delay
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _controller.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load cities. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    _buildAppBar(),
                    _buildSearchBar(),
                    _buildCityList(),
                  ],
                ),
    );
  }

  Widget _buildLoadingState() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('Loading...'),
            background: ShimmerLoading(
              width: double.infinity,
              height: 200,
              borderRadius: 0,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: List.generate(
                5,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ShimmerLoading(
                    width: double.infinity,
                    height: 100,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Travel Assistant',
          style: TextStyle(
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
            Image.network(
              'https://images.unsplash.com/photo-1526778548025-fa2f459cd5ce?auto=format&fit=crop&w=1200&q=80',
              fit: BoxFit.cover,
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

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search cities...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
          onChanged: (value) {
            context.read<CityProvider>().setSearchQuery(value);
          },
        ),
      ),
    );
  }

  Widget _buildCityList() {
    return Consumer<CityProvider>(
      builder: (context, cityProvider, child) {
        final cities = cityProvider.filteredCities;
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final city = cities[index];
              return FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        cityProvider.selectCity(city);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TravelInfoScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            // City Image
                            Hero(
                              tag: 'city_${city.name}',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: city.imageUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const ShimmerLoading(
                                    width: 100,
                                    height: 100,
                                    borderRadius: 10,
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // City Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    city.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${city.attractions.length} attractions',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Arrow Icon
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            childCount: cities.length,
          ),
        );
      },
    );
  }
} 