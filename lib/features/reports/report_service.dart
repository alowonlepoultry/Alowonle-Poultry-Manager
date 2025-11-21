import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logs/log_repository.dart';

final reportServiceProvider = Provider<ReportService>((ref) {
  final logRepo = ref.watch(logRepositoryProvider);
  return ReportService(logRepo);
});

class ReportService {
  final LogRepository _logRepo;

  ReportService(this._logRepo);

  ReportData getReportData(DateTime startDate, DateTime endDate) {
    final logs = _logRepo.getLogsByDateRange(startDate, endDate);

    final totalEggs = logs.fold<int>(0, (sum, log) => sum + log.eggsCollected);
    final totalMortality = logs.fold<int>(0, (sum, log) => sum + log.mortality);
    final totalFeed = logs.fold<double>(0, (sum, log) => sum + log.feedGiven);

    return ReportData(
      startDate: startDate,
      endDate: endDate,
      totalEggs: totalEggs,
      totalMortality: totalMortality,
      totalFeed: totalFeed,
    );
  }
}

class ReportData {
  final DateTime startDate;
  final DateTime endDate;
  final int totalEggs;
  final int totalMortality;
  final double totalFeed;

  ReportData({
    required this.startDate,
    required this.endDate,
    required this.totalEggs,
    required this.totalMortality,
    required this.totalFeed,
  });
}
