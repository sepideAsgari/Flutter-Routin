// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class YearAdapter extends TypeAdapter<Year> {
  @override
  final int typeId = 1;

  @override
  Year read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Year(
      fields[0] as int,
    )..mount = (fields[1] as List)
        .map((dynamic e) => (e as List).cast<int>())
        .toList();
  }

  @override
  void write(BinaryWriter writer, Year obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.mount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YearAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
