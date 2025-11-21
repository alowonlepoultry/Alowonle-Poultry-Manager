import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../core/storage_service.dart';
import '../../data/pen_model.dart';

final penRepositoryProvider = Provider<PenRepository>((ref) {
  final box = ref.watch(pensBoxProvider);
  return PenRepository(box);
});

final penListProvider = StreamProvider<List<Pen>>((ref) {
  final repository = ref.watch(penRepositoryProvider);
  return repository.watchPens();
});

final penProvider = StreamProvider.family<Pen?, String>((ref, id) {
  final repository = ref.watch(penRepositoryProvider);
  return repository.watchPen(id);
});

class PenRepository {
  final Box<Pen> _box;
  final _uuid = const Uuid();

  PenRepository(this._box);

  Stream<List<Pen>> watchPens() {
    return _box
        .watch()
        .map((event) => _box.values.toList())
        .startWith(_box.values.toList());
  }

  Stream<Pen?> watchPen(String id) {
    return _box
        .watch(key: id)
        .map((event) => _box.get(id))
        .startWith(_box.get(id));
  }

  Pen? getPen(String id) {
    return _box.get(id);
  }

  Future<void> addPen({
    required String name,
    required String breed,
    required int initialCount,
    required DateTime dateStarted,
  }) async {
    final id = _uuid.v4();
    final pen = Pen(
      id: id,
      name: name,
      breed: breed,
      initialCount: initialCount,
      dateStarted: dateStarted,
    );
    await _box.put(id, pen);
  }

  Future<void> updatePen(Pen pen) async {
    await pen.save();
  }

  Future<void> deletePen(String id) async {
    await _box.delete(id);
  }
}
