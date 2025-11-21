import 'package:hive_ce/hive.dart';

part 'daily_log_model.g.dart';

@HiveType(typeId: 2)
class DailyLog extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String penId;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  int mortality;

  @HiveField(4)
  double feedGiven;

  @HiveField(5)
  String feedTypeId;

  @HiveField(6)
  int eggsCollected;

  DailyLog({
    required this.id,
    required this.penId,
    required this.date,
    required this.mortality,
    required this.feedGiven,
    required this.feedTypeId,
    required this.eggsCollected,
  });
}
