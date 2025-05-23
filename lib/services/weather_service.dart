import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = 'YOUR_OPENWEATHERMAP_API_KEY'; // Replace with your API key
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> getWeather(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?q=$city,IN&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'temperature': data['main']['temp'],
          'description': data['weather'][0]['description'],
          'humidity': data['main']['humidity'],
          'windSpeed': data['wind']['speed'],
        };
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      return {
        'temperature': 'N/A',
        'description': 'Weather data unavailable',
        'humidity': 'N/A',
        'windSpeed': 'N/A',
      };
    }
  }
} 