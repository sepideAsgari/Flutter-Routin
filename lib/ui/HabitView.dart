import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:routine/model/habit.dart';
import 'package:routine/model/taskCall.dart';
import 'package:routine/utils/themeManager.dart';
import 'package:routine/widgets/customIcon.dart';
import 'package:routine/widgets/customText.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../model/yearManager.dart';
import '../utils/customRute.dart';
import '../utils/displaySize.dart';
import '../widgets/customAppBar.dart';
import '../widgets/customInkWell.dart';
import 'newHabit.dart';

class HabitView extends StatefulWidget {
  const HabitView({super.key, required this.habit, required this.habitId});

  final Habit habit;
  final int habitId;

  @override
  State<HabitView> createState() => _HabitViewState();
}

class _HabitViewState extends State<HabitView> {
  Jalali j = Jalali.fromDateTime(DateTime.now());
  Jalali start = Jalali.fromDateTime(DateTime.now());

  int dayMonth = 31;

  List days = ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج'];

  @override
  void initState() {
    start = Jalali(j.year, j.month, 1);
    dayMonth = j.monthLength + (start.weekDay - 1);
    start = start - (start.weekDay - 1);
    super.initState();
  }

  bool checkM(Jalali jalali) {
    if (jalali.month == j.month) {
      if (jalali.day > j.day) {
        return false;
      }
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.habitId.toString());
    bool isDark =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    double w = (Ds.size.width - 32);
    return Scaffold(
      body: SafeArea(
          child: ValueListenableBuilder(
        valueListenable: Hive.box<Habit>('habits').listenable(),
        builder: (context, value, child) {
          Habit? habit = value.getAt(widget.habitId);
          YearManager yearManager =
              YearManager(widget.habitId, habit!.completed);
          TaskCall taskCall = yearManager.getTaskCall();
          return Column(
            children: [
              CustomAppBar(name: widget.habit.name, widgets: [
                const SizedBox(
                  width: 8,
                ),
                CustomIconButton(
                  pngIcon: PngIcon.delete,
                  accent: false,
                  colorStyle: ColorStyle.h1,
                  onClick: () {
                    value.deleteAt(widget.habitId);
                    Rute.navigateBack(context);
                  },
                ),
                const SizedBox(
                  width: 8,
                ),
                CustomIconButton(
                  pngIcon: PngIcon.edit,
                  accent: false,
                  colorStyle: ColorStyle.h1,
                  onClick: () {
                    Rute.navigate(
                        context, NewHabit(editable: true, habit: habit));
                  },
                ),
                // const SizedBox(
                //   width: 8,
                // ),
                // CustomIconButton(
                //     pngIcon: PngIcon.share,
                //     accent: false,
                //     colorStyle: ColorStyle.h1),
              ]),
              Container(
                height: 70,
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                    color:
                        isDark ? CustomColor.itemDark : CustomColor.itemLight,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.03),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset.zero)
                    ]),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    item('پیشرفت', '${taskCall.taskPercent}%', null),
                    item('از دست رفته', taskCall.taskMiss.toString(),
                        CustomColor.orange),
                    item('انجام شده', taskCall.taskDone.toString(),
                        CustomColor.green),
                    item('کل', taskCall.allTask.toString(), null),
                  ],
                ),
              ),
              title('تاریخچه', format1(j)),
              Container(
                width: w,
                height: ((w / 7) * (dayMonth > 35 ? 7 : 6)) + 8,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                    color:
                        isDark ? CustomColor.itemDark : CustomColor.itemLight,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.03),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset.zero)
                    ]),
                child: Column(
                  children: [
                    Container(
                      height: (w / 7),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          for (int i = 0; i < days.length; i++)
                            Expanded(
                                child: Center(
                              child: CustomText(
                                text: days[(days.length - 1) - i],
                                colorStyle: ColorStyle.h3,
                                textSize: 16,
                              ),
                            ))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: GridView.builder(
                          itemCount: dayMonth < 35 ? 35 : dayMonth,
                          padding: const EdgeInsets.all(8),
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 7),
                          itemBuilder: (context, index) {
                            return Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(4),
                              child: CustomInkWell(
                                onClick: () {
                                  if ((start + index) < j) {
                                    yearManager.editDayInMonth(
                                        (start + index), (start + index).day);
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: (start + index).day == j.day
                                              ? CustomColor()
                                                  .accentColor(CatchTheme
                                                      .getAccentColor())
                                                  .withOpacity(.9)
                                              : Colors.transparent,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(50),
                                      color: yearManager.dayCheckInMonth(
                                              (start + index),
                                              (start + index).day)
                                          ? CustomColor()
                                              .accentColor(
                                                  CatchTheme.getAccentColor())
                                              .withOpacity(.9)
                                          : Colors.transparent),
                                  child: CustomText(
                                    text: '${(start + index).day}',
                                    colorStyle: ColorStyle.h2,
                                    color: yearManager.dayCheckInMonth(
                                            (start + index),
                                            (start + index).day)
                                        ? CustomColor.textH1Dark
                                        : isDark
                                            ? CustomColor.textH3Dark
                                                .withOpacity(
                                                    checkM((start + index))
                                                        ? 1
                                                        : .3)
                                            : CustomColor.textH3Light
                                                .withOpacity(
                                                    checkM((start + index))
                                                        ? 1
                                                        : .3),
                                    textSize: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      )),
    );
  }

  Widget title(String name, String value) {
    return Container(
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          CustomText(
            text: value,
            colorStyle: ColorStyle.h2,
            textSize: 16,
          ),
          const Spacer(),
          CustomText(
            text: name,
            colorStyle: ColorStyle.h2,
            textSize: 16,
          )
        ],
      ),
    );
  }

  String format1(Date d) {
    final f = d.formatter;
    return ' ${f.mN} , ${f.yyyy}';
  }

  Widget item(String name, value, Color? color) {
    return Expanded(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          text: value,
          colorStyle: ColorStyle.h1,
          textSize: 20,
          color: color,
        ),
        CustomText(
          text: name,
          colorStyle: ColorStyle.h2,
          textSize: 12,
        )
      ],
    ));
  }
}
