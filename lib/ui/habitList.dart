import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:routine/model/habit.dart';
import 'package:routine/model/yearManager.dart';
import 'package:routine/utils/themeManager.dart';
import 'package:routine/widgets/customButton.dart';
import 'package:routine/widgets/customText.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../utils/customRute.dart';
import '../utils/displaySize.dart';
import 'HabitView.dart';

class HabitList extends StatefulWidget {
  const HabitList({super.key});

  @override
  State<HabitList> createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  Jalali j = Jalali.fromDateTime(DateTime.now());
  List<Habit> habitsBase = [];
  List<Habit> habitsDone = [];

  @override
  initState() {
    init();
    super.initState();
  }

  init() async {
    Box<Habit> box = Hive.box<Habit>('habits');
    List<Habit> habits = box.values.toList();
    int i = 0;
    habitsBase = [];
    habitsDone = [];
    habits.map((e) {
      YearManager yearManager = YearManager(i, e.completed);
      switch (e.repeat) {
        case 'd':
          List day = e.repeatDay.split(',');
          if (day.contains(j.weekDay.toString())) {
            if (!yearManager.dayCheckInMonth(j, j.day)) {
              habitsBase.add(e);
            } else {
              habitsDone.add(e);
            }
          }
          break;
        case 'w':
          if (!yearManager.dayCheckInMonth(j, j.day)) {
            habitsBase.add(e);
          } else {
            habitsDone.add(e);
          }
          break;
        case 'y':
          List day = e.repeatDay.split(',');
          if (day.contains(j.day.toString())) {
            if (!yearManager.dayCheckInMonth(j, j.day)) {
              habitsBase.add(e);
            } else {
              habitsDone.add(e);
            }
          }
          break;
      }
      i++;
    }).toList();
    Future.delayed(
      Duration.zero,
      () {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Habit>('habits').listenable(),
      builder: (context, value, child) {
        return Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: habitsBase.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                Habit? habit = habitsBase.elementAt(index);
                return HabitListView(
                  habit: habit,
                  index: index,
                  done: false,
                  onClick: () {
                    YearManager yearManager =
                        YearManager(index, habit.completed);
                    yearManager.editDayInMonth(j, j.day);
                    init();
                  },
                );
              },
            ),
            habitsDone.isNotEmpty
                ? Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24, top: 16),
                    child: const CustomText(
                        text: 'انجام شده', colorStyle: ColorStyle.h2))
                : Container(),
            habitsDone.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: habitsDone.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      Habit? habit = habitsDone.elementAt(index);
                      return HabitListView(
                        habit: habit,
                        index: index,
                        done: true,
                        onClick: () {},
                      );
                    },
                  )
                : Container(),
          ],
        );
      },
    );
  }
}

class HabitListView extends StatefulWidget {
  const HabitListView(
      {super.key,
      required this.habit,
      required this.index,
      required this.onClick,
      required this.done});

  final Habit habit;
  final int index;
  final OnClick onClick;
  final bool done;

  @override
  State<HabitListView> createState() => _HabitListViewState();
}

class _HabitListViewState extends State<HabitListView> {
  double margin = 0;
  double start = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Rute.navigate(
            context, HabitView(habit: widget.habit, habitId: widget.index));
      },
      onHorizontalDragStart: (details) {
        if (!widget.done) {
          setState(() {
            setState(() {
              start = details.globalPosition.dx;
            });
          });
        }
      },
      onHorizontalDragUpdate: (details) {
        if (!widget.done) {
          if (details.delta.dx < 0) {
            if (start - details.globalPosition.dx < 100 &&
                start - details.globalPosition.dx >= 0) {
              setState(() {
                margin = start - details.globalPosition.dx;
              });
            }
          } else {
            if (start - details.globalPosition.dx >= 0 &&
                start - details.globalPosition.dx < 100) {
              setState(() {
                margin = start - details.globalPosition.dx;
              });
            }
          }
        }
      },
      onHorizontalDragEnd: (details) {
        if (!widget.done) {
          if (margin > 70) {
            widget.onClick.call();
          }
          setState(() {
            margin = 0;
            start = 0;
          });
        }
      },
      child: Stack(
        children: [
          Positioned(
              child: Container(
            width: 45,
            height: 45,
            margin: EdgeInsets.only(
                top: 10,
                left:
                    margin < 61 ? Ds.size.width - margin : Ds.size.width - 61),
            decoration: BoxDecoration(
                color: CustomColor()
                    .accentColor(widget.habit.color)
                    .withOpacity(.4),
                borderRadius: BorderRadius.circular(15)),
            child: Icon(
              widget.done ? Icons.close : Icons.check,
              color: margin > 70
                  ? widget.done
                      ? Colors.red
                      : Colors.green
                  : Colors.white,
            ),
          )),
          Positioned(
            child: Container(
              margin: EdgeInsets.only(
                  left: 16, top: 8, bottom: 8, right: 16 + margin),
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                  color: CustomColor()
                      .accentColor(widget.habit.color)
                      .withOpacity(widget.done ? .1 : .4),
                  borderRadius: BorderRadius.circular(15)),
              child: CustomText(
                text: widget.habit.name,
                colorStyle: widget.done ? ColorStyle.h3 : ColorStyle.h1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
