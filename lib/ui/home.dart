import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:routine/ui/habitAllTime.dart';
import 'package:routine/utils/my_notification.dart';
import 'package:routine/widgets/customIcon.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../model/habit.dart';
import '../utils/customRute.dart';
import '../utils/subscribe.dart';
import '../utils/themeManager.dart';
import '../widgets/customHomeTab.dart';
import '../widgets/customText.dart';
import 'habitList.dart';
import 'habitWeekList.dart';
import 'menu.dart';
import 'newHabit.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController pageController = PageController();

  MyNotification myNotification = MyNotification();

  int tabSelected = 0;

  @override
  void initState() {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    myNotification.init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // CustomIconButton(
                //     pngIcon: PngIcon.chart,
                //     accent: false,
                //     colorStyle: ColorStyle.h1,
                //     onClick: () {}),
                const SizedBox(
                  width: 8,
                ),
                CustomIconButton(
                    pngIcon: PngIcon.add,
                    accent: false,
                    colorStyle: ColorStyle.h1,
                    onClick: () {
                      if (Hive.box<Habit>('habits').length == 5) {
                        if (Subscribe.getSubscribe()) {
                          Rute.navigate(
                              context,
                              const NewHabit(
                                editable: false,
                              ));
                        } else {
                          // ----------
                        }
                      } else {
                        Rute.navigate(
                            context,
                            const NewHabit(
                              editable: false,
                            ));
                      }
                    }),
                Spacer(),
                CustomIconButton(
                    pngIcon: PngIcon.menu,
                    accent: false,
                    colorStyle: ColorStyle.h1,
                    onClick: () {
                      Rute.navigate(context, const Menu());
                    })
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          title('عادت ها'),
          date(),
          CustomHomeTab(
            tabSelected: tabSelected,
            onSelected: (i) {
              pageController.animateToPage(i,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn);
              setState(() {
                tabSelected = i;
              });
            },
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              scrollDirection: Axis.horizontal,
              onPageChanged: (value) {
                setState(() {
                  tabSelected = value;
                });
              },
              reverse: true,
              children: const [HabitList(), HabitWeekList(), HabitAllTime()],
            ),
          )
        ],
      )),
    );
  }

  Widget title(String name) {
    return Container(
      height: 30,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 8),
      alignment: Alignment.centerRight,
      child: CustomText(text: name, colorStyle: ColorStyle.h1, textSize: 26),
    );
  }

  Widget date() {
    Jalali j = Jalali.fromDateTime(DateTime.now());
    return Container(
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 0),
      alignment: Alignment.centerRight,
      child: CustomText(
          text: '${j.year}/${j.month}/${j.day}',
          colorStyle: ColorStyle.h2,
          textSize: 12),
    );
  }
}
