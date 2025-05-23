import 'package:flutter/foundation.dart';
import '../models/city.dart';

class CityProvider with ChangeNotifier {
  City? _selectedCity;
  final List<City> _cities = City.getCities();
  String _searchQuery = '';

  City? get selectedCity => _selectedCity;
  List<City> get cities => _cities;
  List<City> get filteredCities => _searchQuery.isEmpty
      ? _cities
      : _cities
          .where((city) =>
              city.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();

  void selectCity(City city) {
    _selectedCity = city;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSelection() {
    _selectedCity = null;
    notifyListeners();
  }
} 