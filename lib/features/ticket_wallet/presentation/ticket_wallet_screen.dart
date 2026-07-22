import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/colors.dart';
import 'ticket_wallet_viewmodel.dart';
import 'ticket_detail_screen.dart';

class TicketWalletScreen extends StatefulWidget {
  const TicketWalletScreen({super.key});

  @override
  State<TicketWalletScreen> createState() => _TicketWalletScreenState();
}

class _TicketWalletScreenState extends State<TicketWalletScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TicketWalletViewModel>().loadTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketWalletViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (viewModel.tickets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.confirmation_number_outlined,
                  size: 80,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'No tickets yet',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text('Book your first metro ticket'),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: viewModel.tickets.length,
          itemBuilder: (context, index) {
            final ticket = viewModel.tickets[index];
            return _TicketCard(
              ticket: ticket,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TicketDetailScreen(ticket: ticket),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _TicketCard extends StatelessWidget {
  final ticket;
  final VoidCallback onTap;
  
  const _TicketCard({required this.ticket, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${ticket.from.name} → ${ticket.to.name}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _StatusBadge(status: ticket.status),
                ],
              ),
              const SizedBox(height: 8),
              Text('₹${ticket.fare}'),
              Text(
                'Valid until ${_formatTime(ticket.expiryTime)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'active':
        color = AppColors.activeTicket;
        break;
      case 'used':
        color = Colors.grey;
        break;
      case 'expired':
        color = AppColors.expiredTicket;
        break;
      default:
        color = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

