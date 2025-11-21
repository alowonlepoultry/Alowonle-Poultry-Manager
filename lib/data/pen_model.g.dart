// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pen_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PenAdapter extends TypeAdapter<Pen> {
  @override
  final typeId = 0;

  @override
  Pen read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pen(
      id: fields[0] as String,
      name: fields[1] as String,
      breed: fields[2] as String,
      initialCount: (fields[3] as num).toInt(),
      dateStarted: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Pen obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.breed)
      ..writeByte(3)
      ..write(obj.initialCount)
      ..writeByte(4)
      ..write(obj.dateStarted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PenAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
