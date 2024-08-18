import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:routine/model/taskCall.dart';
import 'package:routine/model/year.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'habit.dart';

class YearManager {
  Jalali j = Jalali.fromDateTime(DateTime.now());
  List<Year> years;
  int hiveId;

  YearManager(this.hiveId, this.years);

  Year getYear(Jalali ja) {
    Year year = Year(ja.year);
    if (years.isNotEmpty) {
      years.map((e) {
        if (e.id == ja.year) {
          year = e;
        }
      }).toList();
    }
    return year;
  }

  bool dayCheckInMonth(Jalali jalali, int day) {
    bool check = false;
    years.map((e) {
      if (e.id == jalali.year) {
        if (e.mount[jalali.month - 1].contains(day)) {
          check = true;
        }
      }
    }).toList();
    return check;
  }

  int numberOfMonth() {
    int page = 1;
    try {
      Jalali jalali = getJalaliStart();
      jalali = Jalali(jalali.year, jalali.month, 1);
      if (jalali.year < j.year) {
        while (true) {
          Jalali jalali2 = jalali + jalali.monthLength;
          if (jalali2.month < j.month) {
            jalali = jalali2;
            page++;
          } else {
            return page;
          }
        }
      } else {
        if (jalali.month < j.month) {
          while (true) {
            Jalali jalali2 = jalali + jalali.monthLength;
            if (jalali2.month < j.month) {
              jalali = jalali2;
              page++;
            } else {
              return page;
            }
          }
        } else {
          page = 1;
        }
      }
    } catch (e) {
      print(e);
      return page;
    }
    return page;
  }

  bool dayCheck(int day) {
    Year year = getYear(j);
    bool check = false;
    year.mount[j.month - 1].map((e) {
      if (e == day) {
        check = true;
      }
    }).toList();
    return check;
  }

  editDayInMonth(Jalali ja, int day) {
    Habit? habit = getHabit();
    List date = habit!.createdDate.split('/');
    Jalali startDate =
        Jalali(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]));
    if (ja.distanceTo(startDate) > 0) {
      habit.createdDate = '${ja.year}/${ja.month}/${ja.day}';
      saveInHiveHabit(habit);
    }

    List<int> days = getYear(ja).mount[ja.month - 1];
    if (days.contains(day)) {
      days.remove(day);
    } else {
      days.add(day);
    }
    toYear(ja, days);
  }

  toYear(Jalali ja, List<int> days) {
    bool check = false;
    years.map((e) {
      if (e.id == ja.year) {
        check = true;
      }
    }).toList();

    if (check) {
      years.map((e) {
        if (e.id == ja.year) {
          e.mount[ja.month - 1] = days;
        }
      }).toList();
    } else {
      Year year = Year(ja.year);
      year.mount[ja.month - 1] = days;
      years.add(year);
    }
    saveInHive();
  }

  int daysInStart() {
    Habit? habit = getHabit();
    List date = habit!.createdDate.split('/');
    Jalali startDate =
        Jalali(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]));
    return startDate.distanceTo(j);
  }

  Jalali getJalaliStart() {
    Habit? habit = getHabit();
    List date = habit!.createdDate.split('/');
    return Jalali(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]));
  }

  TaskCall getTaskCall() {
    Habit? habit = getHabit();
    switch (habit!.repeat) {
      case 'd':
        try {
          int task = 0;
          List day = [];
          if (habit.repeatDay.length > 1) {
            day = habit.repeatDay.split(',');
          } else {
            day.add(habit.repeatDay.toString());
          }
          List date = habit.createdDate.split('/');
          Jalali startDate = Jalali(
              int.parse(date[0]), int.parse(date[1]), int.parse(date[2]));

          int taskDays = startDate.distanceTo(j);

          if (taskDays == 0) {
            if (day.contains(j.weekDay.toString())) {
              task++;
            }
          } else {
            for (int i = 1; i <= taskDays; i++) {
              Jalali j2 = startDate + i;
              if (day.contains(j2.weekDay.toString())) {
                task++;
              }
            }
          }
          int taskDone = 0;
          habit.completed.map((e) {
            e.mount.map((e) {
              taskDone += e.length;
            }).toList();
          }).toList();
          int taskPercent = 0;
          try {
            int all = ((j.monthLength ~/ 7) * day.length);
            taskPercent = ((100 / all) * taskDone).round();
          } catch (e) {}
          return TaskCall(task, taskDone,
              task - taskDone > 0 ? task - taskDone : 0, taskPercent);
        } catch (e) {
          print(e);
          return TaskCall(0, 0, 0, 0);
        }
      case 'w':
        int day = int.parse(habit.repeatDay);
        List date = habit.createdDate.split('/');
        Jalali startDate =
            Jalali(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]));
        int taskDays = startDate.distanceTo(j);
        int week = taskDays ~/ 7;
        int task = week * day;
        int taskDone = 0;
        habit.completed.map((e) {
          e.mount.map((e) {
            taskDone += e.length;
          }).toList();
        }).toList();
        int taskPercent = 0;
        try {
          int all = ((j.monthLength ~/ 7) * day);
          taskPercent = ((100 / all) * taskDone).round();
        } catch (e) {}
        return TaskCall(task, taskDone, task - taskDone, taskPercent);
      case 'm':
        int task = 0;
        List day = [];
        if (habit.repeatDay.length > 1) {
          day = habit.repeatDay.split(',');
        } else {
          day.add(habit.repeatDay.toString());
        }
        List date = habit.createdDate.split('/');
        Jalali startDate =
            Jalali(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]));
        int taskDays = startDate.distanceTo(j);

        if (taskDays == 0) {
          if (day.contains(j.day.toString())) {
            task++;
          }
        } else {
          for (int i = 1; i <= taskDays; i++) {
            Jalali j2 = startDate + i;
            if (day.contains(j2.day.toString())) {
              task++;
            }
          }
        }

        int taskDone = 0;
        habit.completed.map((e) {
          e.mount.map((e) {
            taskDone += e.length;
          }).toList();
        }).toList();
        int taskPercent = 0;
        try {
          taskPercent = ((100 / task) * taskDone).round();
        } catch (e) {}
        return TaskCall(task, taskDone, task - taskDone, taskPercent);
      default:
        return TaskCall(0, 0, 0, 0);
    }
  }

  saveInHive() {
    Habit? habit = getHabit();
    habit!.completed = years;
    Hive.box<Habit>('habits').putAt(hiveId, habit);
  }

  saveInHiveHabit(Habit habit) {
    Hive.box<Habit>('habits').putAt(hiveId, habit);
  }

  Habit? getHabit() {
    return Hive.box<Habit>('habits').getAt(hiveId);
  }
}
