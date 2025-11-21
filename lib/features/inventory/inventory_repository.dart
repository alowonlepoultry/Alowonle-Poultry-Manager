import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../core/storage_service.dart';
import '../../data/inventory_item_model.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final box = ref.watch(inventoryBoxProvider);
  return InventoryRepository(box);
});

final inventoryListProvider = StreamProvider<List<InventoryItem>>((ref) {
  final repository = ref.watch(inventoryRepositoryProvider);
  return repository.watchInventory();
});

class InventoryRepository {
  final Box<InventoryItem> _box;
  final _uuid = const Uuid();

  InventoryRepository(this._box);

  // Get stream of all items
  Stream<List<InventoryItem>> watchInventory() {
    // Emit current values immediately, then listen for changes
    return _box
        .watch()
        .map((event) => _box.values.toList())
        .startWith(_box.values.toList());
  }

  // Get current list (non-reactive)
  List<InventoryItem> getAllItems() {
    return _box.values.toList();
  }

  // Create new item
  Future<void> createItem({
    required String name,
    required double currentBalance,
    required double lowStockThreshold,
  }) async {
    final id = _uuid.v4();
    final item = InventoryItem(
      id: id,
      name: name,
      currentBalance: currentBalance,
      lowStockThreshold: lowStockThreshold,
    );
    await _box.put(id, item);
  }

  // Add stock
  Future<void> addStock(String id, double amount) async {
    final item = _box.get(id);
    if (item != null) {
      item.currentBalance += amount;
      await item.save();
    }
  }

  // Update threshold
  Future<void> updateThreshold(String id, double newThreshold) async {
    final item = _box.get(id);
    if (item != null) {
      item.lowStockThreshold = newThreshold;
      await item.save();
    }
  }

  // Delete item
  Future<void> deleteItem(String id) async {
    await _box.delete(id);
  }
}
