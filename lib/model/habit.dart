import 'package:hive_flutter/hive_flutter.dart';
import 'package:routine/model/year.dart';

import 'goal.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String description;
  @HiveField(3, defaultValue: 0)
  int color;
  @HiveField(4, defaultValue: 'd')
  String repeat;
  @HiveField(5, defaultValue: '1,2,3,4,5,6,7')
  String repeatDay;
  @HiveField(6)
  String reminderTime;
  @HiveField(7)
  String createdDate;
  @HiveField(8)
  String createdTime;
  @HiveField(9, defaultValue: [])
  List<Year> completed = [];
  @HiveField(10, defaultValue: false)
  bool reminder;
  @HiveField(11, defaultValue: true)
  bool active;
  @HiveField(12, defaultValue: '')
  String endDate;
  @HiveField(13, defaultValue: false)
  bool goal;
  @HiveField(14, defaultValue: 0)
  int numberOfGoal;
  @HiveField(15, defaultValue: 'time')
  String model;
  @HiveField(16, defaultValue: [])
  List<Goal> completedGoal = [];

  Habit(this.id, this.name, this.color, this.repeat, this.repeatDay,
      this.createdDate, this.createdTime,
      {this.description = '',
      this.reminderTime = '',
      this.reminder = false,
      this.active = true,
      this.endDate = '',
      this.goal = false,
      this.numberOfGoal = 0,
      this.model = 'time'});
}
