// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 0;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit(
      fields[0] as int,
      fields[1] as String,
      fields[3] == null ? 0 : fields[3] as int,
      fields[4] == null ? 'd' : fields[4] as String,
      fields[5] == null ? '1,2,3,4,5,6,7' : fields[5] as String,
      fields[7] as String,
      fields[8] as String,
      description: fields[2] as String,
      reminderTime: fields[6] as String,
      reminder: fields[10] == null ? false : fields[10] as bool,
      active: fields[11] == null ? true : fields[11] as bool,
      endDate: fields[12] == null ? '' : fields[12] as String,
      goal: fields[13] == null ? false : fields[13] as bool,
      numberOfGoal: fields[14] == null ? 0 : fields[14] as int,
      model: fields[15] == null ? 'time' : fields[15] as String,
    )
      ..completed = fields[9] == null ? [] : (fields[9] as List).cast<Year>()
      ..completedGoal =
          fields[16] == null ? [] : (fields[16] as List).cast<Goal>();
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.repeat)
      ..writeByte(5)
      ..write(obj.repeatDay)
      ..writeByte(6)
      ..write(obj.reminderTime)
      ..writeByte(7)
      ..write(obj.createdDate)
      ..writeByte(8)
      ..write(obj.createdTime)
      ..writeByte(9)
      ..write(obj.completed)
      ..writeByte(10)
      ..write(obj.reminder)
      ..writeByte(11)
      ..write(obj.active)
      ..writeByte(12)
      ..write(obj.endDate)
      ..writeByte(13)
      ..write(obj.goal)
      ..writeByte(14)
      ..write(obj.numberOfGoal)
      ..writeByte(15)
      ..write(obj.model)
      ..writeByte(16)
      ..write(obj.completedGoal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
