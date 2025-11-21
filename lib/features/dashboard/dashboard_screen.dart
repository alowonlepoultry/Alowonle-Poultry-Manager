import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../pens/pen_repository.dart';
import 'dashboard_provider.dart';
import 'widgets/feed_alert_card.dart';
import 'widgets/production_chart.dart';
import 'widgets/quick_stats_cards.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardStatsProvider);
    final trend = ref.watch(productionTrendProvider);
    final lowStockItems = ref.watch(lowStockItemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ref
          .watch(penListProvider)
          .when(
            data: (pens) {
              if (pens.isEmpty) {
                return _buildEmptyState(context);
              }
              return _buildDashboard(context, stats, trend, lowStockItems);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.dashboard_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No pens active.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.push('/pens/add'),
            child: const Text("Add Your First Pen"),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    DashboardStats stats,
    List<DailyProduction> trend,
    lowStockItems,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (stats.hasLowStock) ...[
            FeedAlertCard(lowStockItems: lowStockItems),
            const SizedBox(height: 16),
          ],
          QuickStatsCards(
            totalBirds: stats.totalBirdsAlive,
            todaysEggs: stats.todaysEggs,
          ),
          const SizedBox(height: 16),
          ProductionChart(data: trend),
        ],
      ),
    );
  }
}
