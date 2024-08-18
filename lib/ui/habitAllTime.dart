import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:routine/ui/HabitView.dart';
import 'package:routine/utils/customRute.dart';
import 'package:routine/widgets/customInkWell.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../model/habit.dart';
import '../model/yearManager.dart';
import '../utils/displaySize.dart';
import '../utils/themeManager.dart';
import '../widgets/customText.dart';

class HabitAllTime extends StatelessWidget {
  const HabitAllTime({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Habit>('habits').listenable(),
      builder: (context, value, child) {
        return ListView.builder(
          itemCount: value.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index2) {
            Habit? habit = value.getAt(index2);
            return HabitAllTimeView(habit: habit!, habitId: index2);
          },
        );
      },
    );
  }
}

class HabitAllTimeView extends StatelessWidget {
  HabitAllTimeView({super.key, required this.habit, required this.habitId});

  final Habit habit;
  final int habitId;

  final Jalali j = Jalali.fromDateTime(DateTime.now());

  @override
  Widget build(BuildContext context) {
    bool isDark =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    YearManager yearManager = YearManager(habitId, habit.completed);
    double h = 100 / 7;
    int w = ((Ds.size.width - 64) / h).round() * 7;
    print('A : ${yearManager.daysInStart()}');
    print('B : $w');
    Jalali start = yearManager.daysInStart() > w
        ? yearManager.getJalaliStart()
        : j - (w - 7);
    return CustomInkWell(
      onClick: () {
        Rute.navigate(context, HabitView(habit: habit, habitId: habitId));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: isDark ? CustomColor.itemDark : CustomColor.itemLight,
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              margin: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  const Spacer(),
                  CustomText(text: habit.name, colorStyle: ColorStyle.h1)
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 100,
              margin: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: yearManager.daysInStart() > w
                    ? yearManager.daysInStart()
                    : w - (7 - j.weekDay),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(1),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: yearManager.dayCheckInMonth(
                              (start + index), (start + index).day)
                          ? CustomColor().accentColor(habit.color)
                          : isDark
                              ? CustomColor.textH3Dark.withOpacity(.2)
                              : CustomColor.textH3Light.withOpacity(.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
