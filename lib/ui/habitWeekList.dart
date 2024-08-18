import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:routine/model/yearManager.dart';
import 'package:routine/widgets/customInkWell.dart';
import 'package:routine/widgets/customText.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../model/habit.dart';
import '../utils/customRute.dart';
import '../utils/displaySize.dart';
import '../utils/themeManager.dart';
import 'HabitView.dart';

class HabitWeekList extends StatefulWidget {
  const HabitWeekList({super.key});

  @override
  State<HabitWeekList> createState() => _HabitWeekListState();
}

class _HabitWeekListState extends State<HabitWeekList> {
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
            return HabitWeekView(habit: habit!, habitId: index2);
          },
        );
      },
    );
  }
}

class HabitWeekView extends StatefulWidget {
  const HabitWeekView({super.key, required this.habit, required this.habitId});

  final Habit habit;
  final int habitId;

  @override
  State<HabitWeekView> createState() => _HabitWeekViewState();
}

class _HabitWeekViewState extends State<HabitWeekView> {
  Jalali j = Jalali.fromDateTime(DateTime.now());
  Jalali start = Jalali.fromDateTime(DateTime.now());

  List days = [
    'شنبه',
    'یکشنبه',
    'دوشنبه',
    'سه شنبه',
    'چهارشنبه',
    'پنجشنبه',
    'جمعه'
  ];
  int toWeek = 0;
  late Habit habit;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    habit = widget.habit;
    start = start - j.weekDay;
    toWeek = j.weekDay;
  }

  @override
  Widget build(BuildContext context) {
    YearManager yearManager = YearManager(widget.habitId, habit.completed);
    double w = ((Ds.size.width - 40) / 7);
    return CustomInkWell(
      onClick: () {
        Rute.navigate(
            context, HabitView(habit: habit, habitId: widget.habitId));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: CustomColor().accentColor(habit.color).withOpacity(.3),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              margin: EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Spacer(),
                  CustomText(text: habit.name, colorStyle: ColorStyle.h1)
                ],
              ),
            ),
            Container(
              height: w * 1.3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: 7,
                reverse: true,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  int day = (start + (index + 1)).day;
                  return Align(
                    alignment: Alignment.center,
                    child: Container(
                        width: w - 8,
                        height: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white
                                .withOpacity(toWeek == index + 1 ? .2 : 0)),
                        child: Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: CustomText(
                                  text: days[index],
                                  colorStyle: ColorStyle.h2,
                                  textSize: 10,
                                ),
                              ),
                            ),
                            CustomInkWell(
                              onClick: () {
                                if ((start + (index + 1)).weekDay <=
                                    j.weekDay) {
                                  yearManager.editDayInMonth(
                                      (start + (index + 1)), day);
                                }
                              },
                              child: Container(
                                width: (w - 8) - 8,
                                height: (w - 8) - 8,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(bottom: 4),
                                decoration: BoxDecoration(
                                    color: yearManager.dayCheck(day)
                                        ? CustomColor()
                                            .accentColor(habit.color)
                                            .withOpacity(.8)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: yearManager.dayCheck(day)
                                            ? CustomColor()
                                                .accentColor(habit.color)
                                                .withOpacity(.1)
                                            : Colors.white.withOpacity(.3),
                                        width: 2)),
                                child: yearManager.dayCheck(day)
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 18,
                                      )
                                    : CustomText(
                                        text: day.toString(),
                                        colorStyle: ColorStyle.h3,
                                        textSize: 14,
                                      ),
                              ),
                            )
                          ],
                        )),
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
