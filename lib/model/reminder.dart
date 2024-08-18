import 'package:hive_flutter/hive_flutter.dart';

part 'reminder.g.dart';

@HiveType(typeId: 3)
class Reminder {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String description;
  @HiveField(3)
  String habitId;
  @HiveField(4)
  String todoId;

  Reminder(this.id, this.name, this.description,
      {this.habitId = '', this.todoId = ''});
}
