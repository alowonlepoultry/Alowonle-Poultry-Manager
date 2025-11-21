import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../inventory/inventory_repository.dart';
import '../pens/pen_repository.dart';
import 'log_repository.dart';

final logServiceProvider = Provider<LogService>((ref) {
  final logRepo = ref.watch(logRepositoryProvider);
  final inventoryRepo = ref.watch(inventoryRepositoryProvider);
  final penRepo = ref.watch(penRepositoryProvider);
  return LogService(logRepo, inventoryRepo, penRepo);
});

final currentBirdCountProvider = Provider.family<int, String>((ref, penId) {
  final service = ref.watch(logServiceProvider);
  return service.getCurrentBirdCount(penId);
});

class LogService {
  final LogRepository _logRepo;
  final InventoryRepository _inventoryRepo;
  final PenRepository _penRepo;

  LogService(this._logRepo, this._inventoryRepo, this._penRepo);

  int getCurrentBirdCount(String penId) {
    final pen = _penRepo.getPen(penId);
    if (pen == null) return 0;

    final totalMortality = _logRepo.getTotalMortalityForPen(penId);
    return pen.initialCount - totalMortality;
  }

  Future<void> saveLog({
    required String penId,
    required DateTime date,
    required int mortality,
    required double feedGiven,
    required String feedTypeId,
    required int eggsCollected,
    bool forceInventoryUpdate = false,
  }) async {
    // 1. Save the log
    await _logRepo.addLog(
      penId: penId,
      date: date,
      mortality: mortality,
      feedGiven: feedGiven,
      feedTypeId: feedTypeId,
      eggsCollected: eggsCollected,
    );

    // 2. Update inventory (deduct feed)
    await _inventoryRepo.addStock(feedTypeId, -feedGiven);
  }

  bool checkFeedAvailability(String feedTypeId, double feedAmount) {
    final items = _inventoryRepo.getAllItems();
    final item = items.firstWhere(
      (item) => item.id == feedTypeId,
      orElse: () => throw Exception('Feed type not found'),
    );
    return item.currentBalance >= feedAmount;
  }

  double getFeedBalance(String feedTypeId) {
    final items = _inventoryRepo.getAllItems();
    final item = items.firstWhere(
      (item) => item.id == feedTypeId,
      orElse: () => throw Exception('Feed type not found'),
    );
    return item.currentBalance;
  }
}
