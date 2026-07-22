import 'package:flutter/material.dart';
import '../../../data/network/metro_api_service.dart';
import '../../../data/auth/firebase_auth_service.dart';
import '../../../domain/entities/ticket.dart';

class TicketWalletViewModel extends ChangeNotifier {
  final MetroApiService _apiService = MetroApiService();
  final FirebaseAuthService _authService = FirebaseAuthService();
  
  List<Ticket> _tickets = [];
  List<Ticket> get tickets => _tickets;
  
  List<Ticket> get activeTickets => 
      _tickets.where((t) => t.status == 'active').toList();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  Future<void> loadTickets() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final userId = _authService.getCurrentUserId() ?? 'guest';
      final tickets = await _apiService.getUserTickets(userId);
      _tickets = tickets;
    } catch (e) {
      debugPrint('Error loading tickets: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

