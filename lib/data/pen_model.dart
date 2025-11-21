import 'package:hive_ce/hive.dart';

part 'pen_model.g.dart';

@HiveType(typeId: 0)
class Pen extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String breed;

  @HiveField(3)
  int initialCount;

  @HiveField(4)
  DateTime dateStarted;

  Pen({
    required this.id,
    required this.name,
    required this.breed,
    required this.initialCount,
    required this.dateStarted,
  });
}
