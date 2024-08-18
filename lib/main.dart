import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:routine/ui/home.dart';
import 'package:routine/utils/displaySize.dart';
import 'package:routine/utils/subscribe.dart';
import 'package:routine/utils/themeManager.dart';

import 'model/habit.dart';
import 'model/reminder.dart';
import 'model/year.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(YearAdapter());
  Hive.registerAdapter(ReminderAdapter());

  await Hive.openBox<Habit>('habits');
  await CatchTheme.init();
  await Subscribe.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static Brightness brightness =
      CatchTheme.getTheme() ? Brightness.dark : Brightness.light;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    if (CatchTheme.getAuto()) {
      brightness = WidgetsBinding.instance.window.platformBrightness;
    }
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (CatchTheme.getAuto()) {
      if (mounted) {
        setState(() {
          brightness = WidgetsBinding.instance.window.platformBrightness;
        });
      }
    }
    super.didChangePlatformBrightness();
  }

  @override
  Widget build(BuildContext context) {
    Ds.size = MediaQuery.sizeOf(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChangeThemeNotifier(),
        ),
      ],
      child: Consumer<ChangeThemeNotifier>(
        builder: (context, value, child) {
          if (CatchTheme.getAuto()) {
            if (brightness == Brightness.dark) {
              value.switchTheme(true);
            } else {
              value.switchTheme(false);
            }
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: value.getThemeMode,
            theme: MyTheme.lightTheme,
            darkTheme: MyTheme.darkTheme,
            home: const Home(),
          );
        },
      ),
    );
  }
}
