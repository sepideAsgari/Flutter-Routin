import 'package:hive_flutter/hive_flutter.dart';

part 'goal.g.dart';

@HiveType(typeId: 2)
class Goal {
  @HiveField(0)
  int number;
  @HiveField(1)
  String date;

  Goal(this.number, this.date);
}
