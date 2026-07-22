import 'package:flutter/material.dart';
import '../../../data/network/metro_api_service.dart';
import '../../../data/auth/firebase_auth_service.dart';
import '../../../domain/entities/ticket.dart';

class RouteResultViewModel extends ChangeNotifier {
  final MetroApiService _apiService = MetroApiService();
  final FirebaseAuthService _authService = FirebaseAuthService();
  
  bool _isGeneratingTicket = false;
  bool get isGeneratingTicket => _isGeneratingTicket;
  
  Ticket? _generatedTicket;
  Ticket? get generatedTicket => _generatedTicket;
  
  String? _error;
  String? get error => _error;
  
  Future<Ticket?> generateTicket({
    required String fromStationId,
    required String toStationId,
    String passengerType = 'adult',
  }) async {
    _isGeneratingTicket = true;
    _error = null;
    notifyListeners();
    
    try {
      final userId = _authService.getCurrentUserId() ?? 'guest';
      
      // Process payment first
      final paymentResult = await _apiService.processPayment(
        amount: 30.0, // This should come from fare calculation
        method: 'UPI',
        userId: userId,
      );
      
      if (!paymentResult['success']) {
        throw Exception('Payment failed');
      }
      
      // Generate ticket
      final ticket = await _apiService.generateTicket(
        userId: userId,
        fromStationId: fromStationId,
        toStationId: toStationId,
        passengerType: passengerType,
        paymentMethod: 'UPI',
      );
      
      _generatedTicket = ticket;
      notifyListeners();
      return ticket;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    } finally {
      _isGeneratingTicket = false;
      notifyListeners();
    }
  }
}

