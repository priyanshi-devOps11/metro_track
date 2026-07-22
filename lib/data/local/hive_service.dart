
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/station.dart';
import '../../domain/entities/route.dart';

/// Local storage service using Hive
/// Provides offline caching capabilities
class HiveService {
  static const String stationsBox = 'stations';
  static const String routesBox = 'cached_routes';
  static const String userBox = 'user_data';
  
  /// Initialize Hive boxes
  static Future<void> initialize() async {
    await Hive.openBox(stationsBox);
    await Hive.openBox(routesBox);
    await Hive.openBox(userBox);
  }
  
  /// Save stations to cache
  static Future<void> cacheStations(List<Station> stations) async {
    final box = Hive.box(stationsBox);
    final stationsMap = {
      for (var station in stations) station.id: station.toJson()
    };
    await box.put('all_stations', stationsMap);
  }
  
  /// Get cached stations
  static Future<List<Station>?> getCachedStations() async {
    final box = Hive.box(stationsBox);
    final stationsMap = box.get('all_stations') as Map?;
    
    if (stationsMap == null) return null;
    
    return stationsMap.values
        .map((json) => Station.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }
  
  /// Cache a route
  static Future<void> cacheRoute(String key, MetroRoute route) async {
    final box = Hive.box(routesBox);
    await box.put(key, route.toJson());
  }
  
  /// Get cached route
  static Future<MetroRoute?> getCachedRoute(String key) async {
    final box = Hive.box(routesBox);
    final routeJson = box.get(key);
    
    if (routeJson == null) return null;
    
    return MetroRoute.fromJson(Map<String, dynamic>.from(routeJson));
  }
  
  /// Save user ID
  static Future<void> saveUserId(String userId) async {
    final box = Hive.box(userBox);
    await box.put('user_id', userId);
  }
  
  /// Get user ID
  static String? getUserId() {
    final box = Hive.box(userBox);
    return box.get('user_id');
  }
  
  /// Clear all caches
  static Future<void> clearCache() async {
    await Hive.box(stationsBox).clear();
    await Hive.box(routesBox).clear();
  }
}