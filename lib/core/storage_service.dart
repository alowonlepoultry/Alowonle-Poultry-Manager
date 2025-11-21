import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../data/pen_model.dart';
import '../data/inventory_item_model.dart';
import '../data/daily_log_model.dart';

final storageServiceProvider = Provider<StorageService>(
  (ref) => StorageService(),
);

class StorageService {
  late Box<Pen> pensBox;
  late Box<InventoryItem> inventoryBox;
  late Box<DailyLog> logsBox;

  Future<void> init() async {
    // For web, Hive uses IndexedDB automatically, no path needed
    if (!kIsWeb) {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
    }

    // Register Adapters
    Hive.registerAdapter(PenAdapter());
    Hive.registerAdapter(InventoryItemAdapter());
    Hive.registerAdapter(DailyLogAdapter());

    // Open Boxes
    pensBox = await Hive.openBox<Pen>('pens');
    inventoryBox = await Hive.openBox<InventoryItem>('inventory');
    logsBox = await Hive.openBox<DailyLog>('logs');
  }
}

final pensBoxProvider = Provider<Box<Pen>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return storage.pensBox;
});

final inventoryBoxProvider = Provider<Box<InventoryItem>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return storage.inventoryBox;
});

final logsBoxProvider = Provider<Box<DailyLog>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return storage.logsBox;
});
