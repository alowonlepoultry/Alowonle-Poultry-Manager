import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../core/storage_service.dart';
import '../../data/daily_log_model.dart';

final logRepositoryProvider = Provider<LogRepository>((ref) {
  final box = ref.watch(logsBoxProvider);
  return LogRepository(box);
});

final logsListProvider = StreamProvider<List<DailyLog>>((ref) {
  final repository = ref.watch(logRepositoryProvider);
  return repository.watchLogs();
});

final penLogsProvider = StreamProvider.family<List<DailyLog>, String>((
  ref,
  penId,
) {
  final repository = ref.watch(logRepositoryProvider);
  return repository.watchLogsByPen(penId);
});

class LogRepository {
  final Box<DailyLog> _box;
  final _uuid = const Uuid();

  LogRepository(this._box);

  Stream<List<DailyLog>> watchLogs() {
    return _box
        .watch()
        .map((event) => _box.values.toList())
        .startWith(_box.values.toList());
  }

  Stream<List<DailyLog>> watchLogsByPen(String penId) {
    return _box
        .watch()
        .map((event) => _box.values.where((log) => log.penId == penId).toList())
        .startWith(_box.values.where((log) => log.penId == penId).toList());
  }

  List<DailyLog> getLogsByPen(String penId) {
    return _box.values.where((log) => log.penId == penId).toList();
  }

  Future<void> addLog({
    required String penId,
    required DateTime date,
    required int mortality,
    required double feedGiven,
    required String feedTypeId,
    required int eggsCollected,
  }) async {
    final id = _uuid.v4();
    final log = DailyLog(
      id: id,
      penId: penId,
      date: date,
      mortality: mortality,
      feedGiven: feedGiven,
      feedTypeId: feedTypeId,
      eggsCollected: eggsCollected,
    );
    await _box.put(id, log);
  }

  int getTotalMortalityForPen(String penId) {
    return _box.values
        .where((log) => log.penId == penId)
        .fold(0, (sum, log) => sum + log.mortality);
  }

  List<DailyLog> getLogsByDateRange(DateTime startDate, DateTime endDate) {
    return _box.values.where((log) {
      return log.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          log.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }
}
