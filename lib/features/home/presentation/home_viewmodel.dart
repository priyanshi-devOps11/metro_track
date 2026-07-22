import 'package:flutter/material.dart';
import '../../../data/network/metro_api_service.dart';
import '../../../data/local/hive_service.dart';
import '../../../domain/entities/station.dart';
import '../../../domain/entities/route.dart';

/// Home ViewModel
/// Manages state and business logic for home screen
class HomeViewModel extends ChangeNotifier {
  final MetroApiService _apiService = MetroApiService();
  
  // State variables
  List<Station> _stations = [];
  List<Station> get stations => _stations;
  
  Station? _fromStation;
  Station? get fromStation => _fromStation;
  
  Station? _toStation;
  Station? get toStation => _toStation;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _error;
  String? get error => _error;
  
  MetroRoute? _currentRoute;
  MetroRoute? get currentRoute => _currentRoute;
  
  /// Initialize - load stations
  Future<void> initialize() async {
    await loadStations();
  }
  
  /// Load all stations
  Future<void> loadStations() async {
    _setLoading(true);
    _error = null;
    
    try {
      // Try to load from cache first
      final cachedStations = await HiveService.getCachedStations();
      if (cachedStations != null && cachedStations.isNotEmpty) {
        _stations = cachedStations;
        notifyListeners();
      }
      
      // Fetch from API
      final apiStations = await _apiService.getAllStations();
      _stations = apiStations;
      
      // Cache for offline use
      await HiveService.cacheStations(apiStations);
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading stations: $e');
      
      // If API fails but cache exists, keep using cache
      if (_stations.isEmpty) {
        notifyListeners();
      }
    } finally {
      _setLoading(false);
    }
  }
  
  /// Search stations
  Future<List<Station>> searchStations(String query) async {
    if (query.isEmpty) return _stations;
    
    try {
      final results = await _apiService.searchStations(query);
      return results;
    } catch (e) {
      // Fallback to local search
      return _stations.where((station) {
        final nameLower = station.name.toLowerCase();
        final codeLower = station.code.toLowerCase();
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower) || codeLower.contains(queryLower);
      }).toList();
    }
  }
  
  /// Set from station
  void setFromStation(Station? station) {
    _fromStation = station;
    notifyListeners();
  }
  
  /// Set to station
  void setToStation(Station? station) {
    _toStation = station;
    notifyListeners();
  }
  
  /// Swap from and to stations
  void swapStations() {
    final temp = _fromStation;
    _fromStation = _toStation;
    _toStation = temp;
    notifyListeners();
  }
  
  /// Find route between selected stations
  Future<MetroRoute?> findRoute() async {
    if (_fromStation == null || _toStation == null) {
      _error = 'Please select both stations';
      notifyListeners();
      return null;
    }
    
    if (_fromStation!.id == _toStation!.id) {
      _error = 'Source and destination cannot be the same';
      notifyListeners();
      return null;
    }
    
    _setLoading(true);
    _error = null;
    
    try {
      // Check cache first
      final cacheKey = '${_fromStation!.id}_${_toStation!.id}';
      final cachedRoute = await HiveService.getCachedRoute(cacheKey);
      
      if (cachedRoute != null) {
        _currentRoute = cachedRoute;
        notifyListeners();
        return cachedRoute;
      }
      
      // Fetch from API
      final route = await _apiService.findRoute(
        _fromStation!.id,
        _toStation!.id,
      );
      
      _currentRoute = route;
      
      // Cache the route
      await HiveService.cacheRoute(cacheKey, route);
      
      notifyListeners();
      return route;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error finding route: $e');
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }
  
  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
  
  /// Reset selection
  void reset() {
    _fromStation = null;
    _toStation = null;
    _currentRoute = null;
    _error = null;
    notifyListeners();
  }
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

