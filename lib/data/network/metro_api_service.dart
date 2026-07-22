import 'api_client.dart';
import '../../domain/entities/station.dart';
import '../../domain/entities/route.dart';
import '../../domain/entities/ticket.dart';

/// Metro API Service
/// Provides methods for all metro-related API calls
class MetroApiService {
  final ApiClient _client = ApiClient();
  
  /// Get all stations
  Future<List<Station>> getAllStations({String? lineId}) async {
    final response = await _client.get(
      '/stations',
      queryParameters: lineId != null ? {'lineId': lineId} : null,
    );
    
    final List<dynamic> data = response.data['stations'];
    return data.map((json) => Station.fromJson(json)).toList();
  }
  
  /// Search stations
  Future<List<Station>> searchStations(String query) async {
    final response = await _client.get(
      '/stations/search',
      queryParameters: {'q': query},
    );
    
    final List<dynamic> data = response.data['results'];
    return data.map((json) => Station.fromJson(json)).toList();
  }
  
  /// Get station details
  Future<Station> getStationDetails(String stationId) async {
    final response = await _client.get('/stations/$stationId');
    return Station.fromJson(response.data['station']);
  }
  
  /// Find route between stations
  Future<MetroRoute> findRoute(String fromId, String toId) async {
    final response = await _client.post(
      '/routes/find',
      data: {
        'fromStationId': fromId,
        'toStationId': toId,
      },
    );
    
    return MetroRoute.fromJson(response.data['route']);
  }
  
  /// Generate ticket
  Future<Ticket> generateTicket({
    required String userId,
    required String fromStationId,
    required String toStationId,
    String passengerType = 'adult',
    String paymentMethod = 'UPI',
  }) async {
    final response = await _client.post(
      '/tickets/generate',
      data: {
        'userId': userId,
        'fromStationId': fromStationId,
        'toStationId': toStationId,
        'passengerType': passengerType,
        'paymentMethod': paymentMethod,
      },
    );
    
    return Ticket.fromJson(response.data['ticket']);
  }
  
  /// Get user tickets
  Future<List<Ticket>> getUserTickets(String userId) async {
    final response = await _client.get('/tickets/user/$userId');
    
    final List<dynamic> data = response.data['tickets'];
    return data.map((json) => Ticket.fromJson(json)).toList();
  }
  
  /// Validate ticket
  Future<bool> validateTicket(String ticketId) async {
    final response = await _client.post(
      '/tickets/validate',
      data: {'ticketId': ticketId},
    );
    
    return response.data['valid'] ?? false;
  }
  
  /// Get live station info
  Future<Map<String, dynamic>> getLiveStationInfo(String stationId) async {
    final response = await _client.get('/live/station/$stationId');
    return response.data;
  }
  
  /// Process payment (mock)
  Future<Map<String, dynamic>> processPayment({
    required double amount,
    required String method,
    required String userId,
  }) async {
    final response = await _client.post(
      '/tickets/payment/process',
      data: {
        'amount': amount,
        'method': method,
        'userId': userId,
      },
    );
    
    return response.data;
  }
}