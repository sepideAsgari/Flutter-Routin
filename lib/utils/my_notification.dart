import 'dart:ffi';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../model/habit.dart';
import '../model/reminder.dart';
import '../model/year.dart';

@pragma('vm:entry-point')
void printHello(int id) async {
  await hiveInit();
  await notification(id);
  await setAlarm(id);
  await AndroidAlarmManager.cancel(id);
}

@pragma('vm:entry-point')
setAlarm(int id) async {
  Jalali jalali = Jalali.fromDateTime(DateTime.now());
  MyNotification myNotification = MyNotification();
  Reminder? reminder = Hive.box<Reminder>('reminder').get(id);
  Box habitBox = Hive.box<Habit>('habits');
  if (reminder!.habitId.isNotEmpty) {
    Habit habit = habitBox.getAt(int.parse(reminder.habitId));
    List time = habit.reminderTime.split(':');
    jalali.add(hours: int.parse(time[0]), minutes: int.parse(time[1]));
    Reminder reminder2 = Reminder(0, habit.name, '${habit.name} reminder',
        habitId: id.toString());
    switch (habit.repeat) {
      case 'd':
        jalali = jalali + 7;
        myNotification.setAlarm(jalali, reminder2);
        break;
      case 'w':
        jalali = jalali + 1;
        myNotification.setAlarm(jalali, reminder2);
        break;
      case 'm':
        jalali = jalali + jalali.monthLength;
        myNotification.setAlarm(jalali, reminder2);
        break;
    }
  }
}

@pragma('vm:entry-point')
notification(int id) async {
  Box box = await Hive.openBox<Reminder>('reminder');
  Reminder reminder = box.get(id);

  MyNotification myNotification = MyNotification();
  myNotification.init();
  myNotification.show(reminder.name, reminder.description);

  if (reminder.todoId.isNotEmpty) {
    box.delete(id);
  }
}

@pragma('vm:entry-point')
hiveInit() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ReminderAdapter());
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(YearAdapter());
  await Hive.openBox<Reminder>('reminder');
  await Hive.openBox<Habit>('habits');
}

class MyNotification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('launch_background');

  init() async {
    await AndroidAlarmManager.initialize();
    if (!Hive.isBoxOpen('reminder')) {
      await Hive.openBox<Reminder>('reminder');
    }
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  setAlarm(Jalali jalali, Reminder reminder) async {
    int reminderID = Random().nextInt(9999999);
    reminder.id = reminderID;
    await Hive.box<Reminder>('reminder').put(reminderID, reminder);
    await AndroidAlarmManager.oneShotAt(
        jalali.toDateTime(), reminderID, printHello,
        wakeup: true,
        allowWhileIdle: true,
        rescheduleOnReboot: true,
        alarmClock: true);
  }

  show(String title, body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('100', 'HABITS',
            channelDescription: '',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: title);
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {}
  }
}
