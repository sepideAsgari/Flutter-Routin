import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:routine/model/habit.dart';
import 'package:routine/utils/customRute.dart';
import 'package:routine/widgets/customAppBar.dart';
import 'package:routine/widgets/customButton.dart';
import 'package:routine/widgets/customInkWell.dart';
import 'package:routine/widgets/customTextInput.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../utils/alarmManagerSet.dart';
import '../utils/themeManager.dart';
import '../widgets/customColorSelectable.dart';
import '../widgets/customDaySelected.dart';
import '../widgets/customMonthSelected.dart';
import '../widgets/customNumberPickerDialog.dart';
import '../widgets/customRepeatSelect.dart';
import '../widgets/customSwitch.dart';
import '../widgets/customText.dart';
import '../widgets/customWeekSelected.dart';

class NewHabit extends StatefulWidget {
  const NewHabit({super.key, required this.editable, this.habit});

  final bool editable;
  final Habit? habit;

  @override
  State<NewHabit> createState() => _NewHabitState();
}

class _NewHabitState extends State<NewHabit> {
  TextEditingController tECName = TextEditingController();

  Habit? habit;

  int colorSelected = 0;
  int repeatSelect = 2;
  String reminderTime = '00:00';
  bool alarm = false;
  bool goal = false;

  String daySelected = '';

  @override
  initState() {
    init();
    super.initState();
  }

  init() {
    if (widget.editable) {
      habit = widget.habit!;
      tECName.text = habit!.name;
      colorSelected = habit!.color;
      reminderTime = habit!.reminderTime;
      alarm = habit!.reminder;
      switch (habit!.repeat) {
        case 'd':
          repeatSelect = 2;
          break;
        case 'w':
          repeatSelect = 1;
          break;
        case 'm':
          repeatSelect = 0;
          break;
      }
      daySelected = habit!.repeatDay;
      setState(() {});
    }
  }

  edit() async {
    Box box = Hive.box<Habit>('habits');
    String repeat = '';
    switch (repeatSelect) {
      case 0:
        repeat = 'm';
        break;
      case 1:
        repeat = 'w';
        break;
      case 2:
        repeat = 'd';
        break;
    }
    if (tECName.text.isNotEmpty) {
      habit!.name = tECName.text;
      habit!.color = colorSelected;
      habit!.repeat = repeat;
      habit!.repeatDay = daySelected;
      habit!.reminder = alarm;
      habit!.reminderTime = reminderTime;
      await box.put(habit!.id, habit);
      if (alarm) {
        await AlarmManagerSet.deleteAlarmByHabit(habit!.id);
        switch (repeatSelect) {
          case 0:
            AlarmManagerSet.setMonth(
                habit!.id, tECName.text, habit!.repeatDay, habit!.reminderTime);
            break;
          case 1:
            AlarmManagerSet.setWeek(
                habit!.id, tECName.text, habit!.reminderTime);
            break;
          case 2:
            AlarmManagerSet.setDay(
                habit!.id, tECName.text, habit!.repeatDay, habit!.reminderTime);
            break;
        }
      } else {
        await AlarmManagerSet.deleteAlarmByHabit(habit!.id);
      }
      Rute.navigateBack(context);
    }
  }

  save() async {
    Box box = Hive.box<Habit>('habits');
    Jalali j = Jalali.fromDateTime(DateTime.now());
    String repeat = '';
    switch (repeatSelect) {
      case 0:
        repeat = 'm';
        break;
      case 1:
        repeat = 'w';
        break;
      case 2:
        repeat = 'd';
        break;
    }
    if (tECName.text.isNotEmpty) {
      Habit habit = Habit(0, tECName.text, colorSelected, repeat, daySelected,
          '${j.year}/${j.month}/${j.day}', '${j.hour}:${j.minute}',
          reminder: alarm, reminderTime: reminderTime);
      int id = await box.add(habit);
      habit.id = id;
      await box.put(id, habit);
      if (alarm) {
        await AlarmManagerSet.deleteAlarmByHabit(id);
        switch (repeatSelect) {
          case 0:
            AlarmManagerSet.setMonth(
                id, tECName.text, habit.repeatDay, habit.reminderTime);
            break;
          case 1:
            AlarmManagerSet.setWeek(id, tECName.text, habit.reminderTime);
            break;
          case 2:
            AlarmManagerSet.setDay(
                id, tECName.text, habit.repeatDay, habit.reminderTime);
            break;
        }
      } else {
        await AlarmManagerSet.deleteAlarmByHabit(id);
      }
      Rute.navigateBack(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Positioned(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 60),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  CustomAppBar(
                      name: widget.editable ? 'ویرایش عادت' : 'عادت جدید',
                      widgets: []),
                  CustomTextInput(
                    textEditingController: tECName,
                    dark: isDark,
                    width: double.infinity,
                    edgeInsets:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    hint: 'نام عادت',
                  ),
                  title('انتخاب رنگ'),
                  CustomColorSelectable(
                    onSelected: (i) {
                      setState(() {
                        colorSelected = i;
                      });
                    },
                    selected: colorSelected,
                  ),
                  title('تکرار'),
                  CustomRepeatSelect(
                    onSelected: (i) {
                      setState(() {
                        repeatSelect = i;
                      });
                    },
                  ),
                  repeatSelect == 2
                      ? CustomDaySelected(
                          onDaySelect: (days) {
                            setState(() {
                              daySelected = days;
                            });
                          },
                          selected: widget.editable
                              ? habit!.repeat == 'm'
                                  ? daySelected
                                  : ''
                              : '',
                        )
                      : repeatSelect == 1
                          ? CustomWeekSelected(
                              onDaySelect: (days) {
                                setState(() {
                                  daySelected = days;
                                });
                              },
                              number: widget.editable
                                  ? habit!.repeat == 'w'
                                      ? int.parse(habit!.repeatDay)
                                      : 0
                                  : 0,
                            )
                          : CustomMonthSelected(
                              onDaySelect: (days) {
                                setState(() {
                                  daySelected = days;
                                });
                              },
                              selected: widget.editable
                                  ? habit!.repeat == 'm'
                                      ? daySelected
                                      : ''
                                  : '',
                            ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 40,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      children: [
                        CustomSwitch(
                          value: alarm,
                          onSwitch: (value) {
                            setState(() {
                              alarm = value;
                            });
                          },
                        ),
                        const Spacer(),
                        alarm
                            ? CustomInkWell(
                                onClick: () {
                                  CustomNumberPickerDialog.show(context,
                                      (time) {
                                    setState(() {
                                      reminderTime = time;
                                    });
                                  });
                                },
                                child: Container(
                                  height: 35,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  margin: const EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: isDark
                                          ? CustomColor.itemDark
                                          : CustomColor.itemLight),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: CustomText(
                                      text: reminderTime,
                                      colorStyle: ColorStyle.h2,
                                      textSize: 20,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        const CustomText(
                          text: 'یادآوری',
                          colorStyle: ColorStyle.h1,
                          textSize: 20,
                        )
                      ],
                    ),
                  ),
                  // Container(
                  //   height: 40,
                  //   margin:
                  //       const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  //   child: Row(
                  //     children: [
                  //       CustomSwitch(
                  //         value: goal,
                  //         onSwitch: (value) {
                  //           setState(() {
                  //             goal = value;
                  //           });
                  //         },
                  //       ),
                  //       const Spacer(),
                  //       const CustomText(
                  //         text: 'هدف گذاری',
                  //         colorStyle: ColorStyle.h1,
                  //         textSize: 20,
                  //       )
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ),
          Positioned(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: CustomButton(
              width: double.infinity,
              height: 50,
              edgeInsets: const EdgeInsets.all(16),
              text: widget.editable ? 'ویرایش' : 'ذخیره',
              onClick: () {
                if (widget.editable) {
                  edit();
                } else {
                  save();
                }
              },
            ),
          ))
        ],
      )),
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
