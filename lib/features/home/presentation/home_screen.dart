import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/station.dart';
import 'home_viewmodel.dart';
import 'widgets/voice_button.dart';
import '../../route_result/presentation/route_result_screen.dart';
import '../../ticket_wallet/presentation/ticket_wallet_screen.dart';
import '../../voice_assistant/presentation/voice_assistant_screen.dart';
import '../../station_navigator/presentation/station_navigator_screen.dart';

/// Home Screen
/// Main screen with route finder and navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  @override
  void initState() {
    super.initState();
    // Load stations on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<HomeViewModel>().loadStations();
            },
            tooltip: 'Refresh stations',
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }
  
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const _RouteFinder();
      case 1:
        return const TicketWalletScreen();
      case 2:
        return const StationNavigatorScreen();
      case 3:
        return const VoiceAssistantScreen();
      default:
        return const _RouteFinder();
    }
  }
  
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() => _selectedIndex = index);
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Find Route',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.confirmation_number),
          label: 'Tickets',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.near_me),
          label: 'Navigator',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mic),
          label: 'Voice',
        ),
      ],
    );
  }
}

/// Route Finder Widget
class _RouteFinder extends StatelessWidget {
  const _RouteFinder();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading && viewModel.stations.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                AppStrings.findRoute,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.appTagline,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              
              // From Station
              _StationSelector(
                label: AppStrings.fromStation,
                station: viewModel.fromStation,
                onTap: () => _selectStation(context, true),
                icon: Icons.trip_origin,
              ),
              
              const SizedBox(height: 16),
              
              // Swap Button
              Center(
                child: IconButton(
                  icon: const Icon(Icons.swap_vert, size: 32),
                  onPressed: viewModel.swapStations,
                  tooltip: AppStrings.swapStations,
                  color: AppColors.primary,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // To Station
              _StationSelector(
                label: AppStrings.toStation,
                station: viewModel.toStation,
                onTap: () => _selectStation(context, false),
                icon: Icons.place,
              ),
              
              const SizedBox(height: 32),
              
              // Voice Input Button
              const VoiceButton(),
              
              const SizedBox(height: 16),
              
              // Search Button
              ElevatedButton(
                onPressed: viewModel.fromStation != null && 
                          viewModel.toStation != null
                    ? () => _findRoute(context, viewModel)
                    : null,
                child: viewModel.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(AppStrings.searchRoute),
              ),
              
              // Error Message
              if (viewModel.error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: AppColors.error),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          viewModel.error!,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: viewModel.clearError,
                        color: AppColors.error,
                      ),
                    ],
                  ),
                ),
              ],
              
              // Quick Links
              const SizedBox(height: 32),
              _buildQuickLinks(context),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildQuickLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Access',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _QuickLinkCard(
                icon: Icons.train,
                title: 'Live\nTracking',
                color: AppColors.blueLine,
                onTap: () {
                  // Navigate to live tracking
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickLinkCard(
                icon: Icons.account_balance_wallet,
                title: 'Smart\nCard',
                color: AppColors.greenLine,
                onTap: () {
                  // Navigate to smart card
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  void _selectStation(BuildContext context, bool isFrom) async {
    final viewModel = context.read<HomeViewModel>();
    
    final station = await showModalBottomSheet<Station>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _StationPicker(stations: viewModel.stations),
    );
    
    if (station != null) {
      if (isFrom) {
        viewModel.setFromStation(station);
      } else {
        viewModel.setToStation(station);
      }
    }
  }
  
  void _findRoute(BuildContext context, HomeViewModel viewModel) async {
    final route = await viewModel.findRoute();
    
    if (route != null && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RouteResultScreen(route: route),
        ),
      );
    }
  }
}

/// Station Selector Widget
class _StationSelector extends StatelessWidget {
  final String label;
  final Station? station;
  final VoidCallback onTap;
  final IconData icon;
  
  const _StationSelector({
    required this.label,
    required this.station,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    station?.name ?? AppStrings.selectStation,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: station != null 
                          ? AppColors.textPrimary
                          : AppColors.textHint,
                    ),
                  ),
                  if (station != null)
                    Text(
                      station!.code,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

/// Station Picker Bottom Sheet
class _StationPicker extends StatefulWidget {
  final List<Station> stations;
  
  const _StationPicker({required this.stations});

  @override
  State<_StationPicker> createState() => _StationPickerState();
}

class _StationPickerState extends State<_StationPicker> {
  List<Station> _filteredStations = [];
  final _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _filteredStations = widget.stations;
  }
  
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: AppStrings.search,
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: _filterStations,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _filteredStations.length,
                  itemBuilder: (context, index) {
                    final station = _filteredStations[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: station.lineColor != null
                            ? Color(int.parse(station.lineColor!.replaceFirst('#', '0xFF')))
                            : AppColors.primary,
                        child: Text(
                          station.code.substring(0, 2),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      title: Text(station.name),
                      subtitle: Text('${station.code} • ${station.lineName ?? ''}'),
                      trailing: station.isInterchange
                          ? const Icon(Icons.swap_horiz, color: AppColors.interchangeStation)
                          : null,
                      onTap: () => Navigator.pop(context, station),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _filterStations(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStations = widget.stations;
      } else {
        _filteredStations = widget.stations.where((station) {
          final nameLower = station.name.toLowerCase();
          final codeLower = station.code.toLowerCase();
          final queryLower = query.toLowerCase();
          return nameLower.contains(queryLower) || codeLower.contains(queryLower);
        }).toList();
      }
    });
  }
}

/// Quick Link Card
class _QuickLinkCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  
  const _QuickLinkCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}