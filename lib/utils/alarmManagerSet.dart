import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../model/reminder.dart';
import 'my_notification.dart';

class AlarmManagerSet {
  static deleteAlarmByHabit(int id) async {
    await AndroidAlarmManager.initialize();
    late Box<Reminder> box;
    if (!Hive.isBoxOpen('reminder')) {
      box = await Hive.openBox<Reminder>('reminder');
    } else {
      box = Hive.box<Reminder>('reminder');
    }
    List deleteId = [];
    for (int i = 0; i < box.length; i++) {
      Reminder? reminder = box.getAt(i);
      if (reminder!.habitId == id.toString()) {
        await AndroidAlarmManager.cancel(reminder.id);
        deleteId.add(i);
      }
    }
    deleteId.map((e) async {
      await box.deleteAt(e);
    }).toList();
  }

  static setDay(int habitId, String name, String days, String reminderTime) {
    MyNotification myNotification = MyNotification();
    Jalali toDay = Jalali.fromDateTime(DateTime.now());
    List day = [];
    List time = reminderTime.split(':');
    if (days.length > 1) {
      day = days.split(',');
    } else {
      day.add(days.toString());
    }
    day.map((e) {
      Jalali remind = Jalali.fromDateTime(DateTime.now());
      if (int.parse(e) == toDay.weekDay) {
        if (int.parse(time[0]) == toDay.hour) {
          if (int.parse(time[1]) > toDay.minute) {
            remind = Jalali(toDay.year, toDay.month, toDay.day,
                int.parse(time[0]), int.parse(time[1]));
          } else {
            remind = Jalali(toDay.year, toDay.month, toDay.day,
                    int.parse(time[0]), int.parse(time[1])) +
                7;
          }
        } else if (int.parse(time[0]) > toDay.hour) {
          remind = Jalali(toDay.year, toDay.month, toDay.day,
              int.parse(time[0]), int.parse(time[1]));
        } else {
          remind = Jalali(toDay.year, toDay.month, toDay.day,
                  int.parse(time[0]), int.parse(time[1])) +
              7;
        }
      } else if (int.parse(e) > toDay.weekDay) {
        Jalali to = toDay + (int.parse(e) - toDay.weekDay);
        remind = Jalali(
            to.year, to.month, to.day, int.parse(time[0]), int.parse(time[1]));
      } else {
        Jalali to = toDay + (7 - (toDay.weekDay - int.parse(e)));
        remind = Jalali(
            to.year, to.month, to.day, int.parse(time[0]), int.parse(time[1]));
      }

      Reminder reminder = Reminder(0, name, 'وقت انجام عادت شما رسیده است',
          habitId: habitId.toString());
      myNotification.setAlarm(remind, reminder);
    }).toList();
  }

  static setWeek(int habitId, String name, String reminderTime) {
    MyNotification myNotification = MyNotification();
    Jalali toDay = Jalali.fromDateTime(DateTime.now());
    List time = reminderTime.split(':');
    Jalali remind = Jalali.fromDateTime(DateTime.now());

    if (int.parse(time[0]) == toDay.hour) {
      if (int.parse(time[1]) > toDay.minute) {
        remind = Jalali(toDay.year, toDay.month, toDay.day, int.parse(time[0]),
            int.parse(time[1]));
      } else {
        remind = Jalali(toDay.year, toDay.month, toDay.day, int.parse(time[0]),
                int.parse(time[1])) +
            1;
      }
    } else {
      remind = Jalali(toDay.year, toDay.month, toDay.day, int.parse(time[0]),
              int.parse(time[1])) +
          1;
    }

    Reminder reminder = Reminder(0, name, 'وقت انجام عادت شما رسیده است',
        habitId: habitId.toString());
    myNotification.setAlarm(remind, reminder);
  }

  static setMonth(int habitId, String name, String days, String reminderTime) {
    MyNotification myNotification = MyNotification();
    Jalali toDay = Jalali.fromDateTime(DateTime.now());
    List day = [];
    List time = reminderTime.split(':');
    if (days.length > 1) {
      day = days.split(',');
    } else {
      day.add(days.toString());
    }

    day.map((e) {
      Jalali remind = Jalali.fromDateTime(DateTime.now());

      if (int.parse(e) == toDay.day) {
        if (int.parse(time[0]) == toDay.hour) {
          if (int.parse(time[1]) > toDay.minute) {
            remind = Jalali(toDay.year, toDay.month, toDay.day,
                int.parse(time[0]), int.parse(time[1]));
          } else {
            remind = Jalali(toDay.year, toDay.month, int.parse(e),
                    int.parse(time[0]), int.parse(time[1])) +
                toDay.monthLength;
          }
        } else if (int.parse(time[0]) > toDay.hour) {
          remind = Jalali(toDay.year, toDay.month, toDay.day,
              int.parse(time[0]), int.parse(time[1]));
        } else {
          remind = Jalali(toDay.year, toDay.month, int.parse(e),
                  int.parse(time[0]), int.parse(time[1])) +
              toDay.monthLength;
        }
      } else if (int.parse(e) > toDay.day) {
        if (int.parse(e) < toDay.monthLength) {
          remind = Jalali(toDay.year, toDay.month, int.parse(e),
              int.parse(time[0]), int.parse(time[1]));
        }
      } else {
        remind = Jalali(toDay.year, toDay.month, int.parse(e),
                int.parse(time[0]), int.parse(time[1])) +
            toDay.monthLength;
      }

      Reminder reminder = Reminder(0, name, 'وقت انجام عادت شما رسیده است',
          habitId: habitId.toString());
      myNotification.setAlarm(remind, reminder);
    }).toList();
  }
}
