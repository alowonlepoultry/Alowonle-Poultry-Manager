import 'package:hive_ce/hive.dart';

part 'inventory_item_model.g.dart';

@HiveType(typeId: 1)
class InventoryItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double currentBalance;

  @HiveField(3)
  double lowStockThreshold;

  InventoryItem({
    required this.id,
    required this.name,
    required this.currentBalance,
    required this.lowStockThreshold,
  });
}
