import 'package:flutter/material.dart';
import '../../../domain/entities/ticket.dart';

class TicketDetailScreen extends StatelessWidget {
  final Ticket ticket;
  
  const TicketDetailScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ticket Details')),
      body: Center(child: Text('QR Code for ticket ${ticket.id}')),
    );
  }
}