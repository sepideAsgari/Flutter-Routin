import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:routine/widgets/customText.dart';
import '../utils/themeManager.dart';
import '../widgets/customAppBar.dart';
import '../widgets/customColorSelectable.dart';
import '../widgets/customListSelectable.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeThemeNotifier>(
      builder: (context, value, child) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const CustomAppBar(name: 'تنظیمات', widgets: []),
                title('تم'),
                CustomListSelectable(
                  items: ['سیستم', 'تاریک', 'روشن'],
                  selected: value.auto
                      ? 0
                      : value.isDark
                          ? 1
                          : 2,
                  onSelected: (i) {
                    if (i == 0) {
                      value.setAuto(true);
                    } else if (i == 1) {
                      value.setAuto(false);
                      value.switchTheme(true);
                    } else {
                      value.setAuto(false);
                      value.switchTheme(false);
                    }
                  },
                ),
                title('رنگ برنامه'),
                CustomColorSelectable(
                  selected: value.getAccentColor,
                  onSelected: (i) {
                    value.switchAccentColor(i);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget title(String name) {
    return Container(
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      alignment: Alignment.centerRight,
      child: CustomText(text: name, colorStyle: ColorStyle.h2, textSize: 20),
    );
  }
}
