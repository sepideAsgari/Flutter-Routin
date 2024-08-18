import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ChangeThemeNotifier extends ChangeNotifier {
  ThemeMode themeMode =
      CatchTheme.getTheme() ? ThemeMode.dark : ThemeMode.light;

  ThemeMode get getThemeMode => themeMode;

  bool dark = CatchTheme.getTheme();
  bool auto = CatchTheme.getAuto();
  int accentColor = CatchTheme.getAccentColor();

  bool get isDark => dark;
  bool get isAuto => auto;
  int get getAccentColor => accentColor;

  switchTheme(bool isOn) {
    CatchTheme.setTheme(isOn);
    dark = isOn;
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    CatchTheme.setAuto(false);
    notify();
  }

  setAuto(bool b) {
    auto = b;
    CatchTheme.setAuto(b);
    notify();
  }

  switchAccentColor(int i) {
    accentColor = i;
    CatchTheme.setAccentColor(i);
    notify();
  }

  notify() {
    Future.delayed(
      Duration.zero,
      () {
        notifyListeners();
      },
    );
  }
}

class CatchTheme {
  static init() async {
    await Hive.openBox('theme');
  }

  static setTheme(bool isOn) {
    Box box = Hive.box('theme');
    box.put('dark', isOn);
  }

  static bool getTheme() {
    return Hive.box('theme').get('dark', defaultValue: true);
  }

  static setAuto(bool b) {
    Hive.box('theme').put('auto', b);
  }

  static bool getAuto() {
    return Hive.box('theme').get('auto', defaultValue: false);
  }

  static setAccentColor(int id) {
    Hive.box('theme').put('accent_color', id);
  }

  static int getAccentColor() {
    return Hive.box('theme').get('accent_color', defaultValue: 0);
  }
}

class MyTheme {
  static final darkTheme = ThemeData(
      fontFamily: 'vazir',
      scaffoldBackgroundColor: CustomColor.bgDark,
      appBarTheme: AppBarTheme(
        backgroundColor: CustomColor.itemDark,
      ),
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      buttonTheme: const ButtonThemeData(
          colorScheme: ColorScheme.dark(), buttonColor: Colors.blue),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: CustomColor.green,
      ),
      primaryIconTheme: IconThemeData(
        color: CustomColor.textH1Dark,
      ),
      colorScheme: const ColorScheme.dark(),
      indicatorColor: CustomColor.green,
      iconTheme: IconThemeData(color: CustomColor.textH1Dark));

  static final lightTheme = ThemeData(
      fontFamily: 'vazir',
      scaffoldBackgroundColor: CustomColor.bgLight,
      appBarTheme: AppBarTheme(
        backgroundColor: CustomColor.itemLight,
      ),
      brightness: Brightness.light,
      primaryColor: Colors.red,
      buttonTheme: const ButtonThemeData(
          colorScheme: ColorScheme.light(), buttonColor: Colors.red),
      primaryIconTheme: IconThemeData(
        color: CustomColor.bgDark.withOpacity(.6),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: CustomColor.green,
      ),
      colorScheme: const ColorScheme.light(),
      indicatorColor: CustomColor.green,
      iconTheme: IconThemeData(color: CustomColor.bgDark.withOpacity(.6)));
}

class CustomColor {
  // Theme Color

  static Color bgDark = const Color(0xFF111111);
  static Color bgLight = const Color(0xffF6F6F6);

  static Color itemDark = const Color(0xFF18181B);
  static Color itemLight = const Color(0xFFFFFFFF);
  static Color itemColor = CatchTheme.getTheme() ? itemDark : itemLight;

  static Color textH1Dark = const Color(0xFFFFFFFF);
  static Color textH2Dark = const Color(0xD9FFFFFF);
  static Color textH3Dark = const Color(0x80FFFFFF);

  static Color textH1Light = const Color(0xD9141414);
  static Color textH2Light = const Color(0xB3141414);
  static Color textH3Light = const Color(0x80141414);

  static Color getIconColor = CatchTheme.getTheme() ? textH3Dark : textH3Light;

  // --------------------------------------------------//

  Color accentColor(int i) {
    Color color = blue;
    switch (i) {
      case 0:
        color = blue;
        break;
      case 1:
        color = green;
        break;
      case 2:
        color = orange;
        break;
      case 3:
        color = red;
        break;
      case 4:
        color = purple;
        break;
      case 5:
        color = pink;
        break;
    }
    return color;
  }

  // All Colors

  static Color green = const Color(0xFF20C18D);
  static Color blue = const Color(0xFF5a8dee);
  static Color orange = const Color(0xFFFFA929);
  static Color red = const Color(0xFFFF413F);
  static Color purple = const Color(0xFFC711EF);
  static Color pink = const Color(0xFFFF3FC2);

  // -----------------------------------------------//
}

class PngIcon {
  static String settings = 'assets/png/settings.png';
  static String add = 'assets/png/add.png';
  static String backup = 'assets/png/backup.png';
  static String chart = 'assets/png/chart.png';
  static String color = 'assets/png/color.png';
  static String delete = 'assets/png/delete.png';
  static String edit = 'assets/png/edit.png';
  static String habit = 'assets/png/habit.png';
  static String instagram = 'assets/png/instagram.png';
  static String telegram = 'assets/png/telegram.png';
  static String menu = 'assets/png/menu.png';
  static String pap = 'assets/png/pap.png';
  static String premium = 'assets/png/premium.png';
  static String reorder = 'assets/png/reorder.png';
  static String share = 'assets/png/share.png';
  static String star = 'assets/png/star.png';
  static String todo = 'assets/png/todo.png';
}
