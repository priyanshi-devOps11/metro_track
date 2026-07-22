import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/route.dart';
import 'route_result_viewmodel.dart';
import '../../ticket_wallet/presentation/ticket_detail_screen.dart';

class RouteResultScreen extends StatelessWidget {
  final MetroRoute route;
  
  const RouteResultScreen({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.routeDetails),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSummaryCard(context),
                  _buildRouteSteps(context),
                ],
              ),
            ),
          ),
          _buildBookTicketButton(context),
        ],
      ),
    );
  }
  
  Widget _buildSummaryCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'From',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      route.startStation,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward, color: Colors.white),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'To',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      route.endStation,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white30, height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _InfoChip(
                icon: Icons.access_time,
                label: '${route.totalTime} min',
              ),
              _InfoChip(
                icon: Icons.train,
                label: '${route.totalStations} stations',
              ),
              _InfoChip(
                icon: Icons.swap_horiz,
                label: '${route.interchanges} change${route.interchanges != 1 ? 's' : ''}',
              ),
              if (route.fare != null)
                _InfoChip(
                  icon: Icons.currency_rupee,
                  label: '₹${route.fare!.adult}',
                ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildRouteSteps(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Journey Steps',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: route.stations.length,
            itemBuilder: (context, index) {
              final station = route.stations[index];
              return _RouteStepCard(
                station: station,
                isFirst: index == 0,
                isLast: index == route.stations.length - 1,
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildBookTicketButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Consumer<RouteResultViewModel>(
          builder: (context, viewModel, _) {
            return ElevatedButton(
              onPressed: viewModel.isGeneratingTicket
                  ? null
                  : () => _bookTicket(context, viewModel),
              child: viewModel.isGeneratingTicket
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      '${AppStrings.bookTicket} - ₹${route.fare?.adult ?? 0}',
                    ),
            );
          },
        ),
      ),
    );
  }
  
  void _bookTicket(BuildContext context, RouteResultViewModel viewModel) async {
    final ticket = await viewModel.generateTicket(
      fromStationId: route.stations.first.stationId,
      toStationId: route.stations.last.stationId,
    );
    
    if (ticket != null && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TicketDetailScreen(ticket: ticket),
        ),
      );
    } else if (viewModel.error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.error!)),
      );
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _RouteStepCard extends StatelessWidget {
  final RouteStation station;
  final bool isFirst;
  final bool isLast;
  
  const _RouteStepCard({
    required this.station,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isFirst || isLast
                    ? AppColors.primary
                    : Colors.white,
                border: Border.all(
                  color: AppColors.primary,
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              child: isFirst || isLast
                  ? const Icon(
                      Icons.circle,
                      size: 10,
                      color: Colors.white,
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: AppColors.primary.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (station.lineColor != null)
                      Container(
                        width: 4,
                        height: 20,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Color(int.parse(
                            station.lineColor!.replaceFirst('#', '0xFF'),
                          )),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        station.stationName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (station.isInterchange)
                      const Icon(
                        Icons.swap_horiz,
                        color: AppColors.interchangeStation,
                        size: 20,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  station.instruction,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (station.gateNumber > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Gate #${station.gateNumber}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}