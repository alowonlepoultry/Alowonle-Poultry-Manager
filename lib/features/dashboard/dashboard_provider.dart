import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/daily_log_model.dart';
import '../../data/inventory_item_model.dart';
import '../../data/pen_model.dart';
import '../inventory/inventory_repository.dart';
import '../logs/log_repository.dart';
import '../pens/pen_repository.dart';

final dashboardStatsProvider = Provider<DashboardStats>((ref) {
  final pens = ref.watch(penListProvider).valueOrNull ?? [];
  final logs = ref.watch(logsListProvider).valueOrNull ?? [];
  final inventory = ref.watch(inventoryListProvider).valueOrNull ?? [];

  return DashboardStats.calculate(pens, logs, inventory);
});

final productionTrendProvider = Provider<List<DailyProduction>>((ref) {
  final logs = ref.watch(logsListProvider).valueOrNull ?? [];

  final now = DateTime.now();
  final last7Days = List.generate(7, (index) {
    return DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: 6 - index));
  });

  return last7Days.map((date) {
    final eggsOnDate = logs
        .where((log) => _isSameDay(log.date, date))
        .fold<int>(0, (sum, log) => sum + log.eggsCollected);
    return DailyProduction(date: date, eggs: eggsOnDate);
  }).toList();
});

final lowStockItemsProvider = Provider<List<InventoryItem>>((ref) {
  final inventory = ref.watch(inventoryListProvider).valueOrNull ?? [];
  return inventory
      .where((item) => item.currentBalance < item.lowStockThreshold)
      .toList();
});

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

class DashboardStats {
  final int totalBirdsAlive;
  final int todaysEggs;
  final bool hasLowStock;

  DashboardStats({
    required this.totalBirdsAlive,
    required this.todaysEggs,
    required this.hasLowStock,
  });

  static DashboardStats calculate(
    List<Pen> pens,
    List<DailyLog> logs,
    List<InventoryItem> inventory,
  ) {
    final totalInitial = pens.fold<int>(
      0,
      (sum, pen) => sum + pen.initialCount,
    );
    final totalMortality = logs.fold<int>(0, (sum, log) => sum + log.mortality);

    final now = DateTime.now();
    final todaysEggs = logs
        .where((log) => _isSameDay(log.date, now))
        .fold<int>(0, (sum, log) => sum + log.eggsCollected);

    final hasLowStock = inventory.any(
      (item) => item.currentBalance < item.lowStockThreshold,
    );

    return DashboardStats(
      totalBirdsAlive: totalInitial - totalMortality,
      todaysEggs: todaysEggs,
      hasLowStock: hasLowStock,
    );
  }
}

class DailyProduction {
  final DateTime date;
  final int eggs;

  DailyProduction({required this.date, required this.eggs});
}
