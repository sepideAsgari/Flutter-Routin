import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine/utils/themeManager.dart';
import 'package:routine/widgets/customInkWell.dart';

typedef OnSwitch = Function(bool value);

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({super.key, required this.value, required this.onSwitch});

  final bool value;
  final OnSwitch onSwitch;

  @override
  Widget build(BuildContext context) {
    bool isDark =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    return CustomInkWell(
      onClick: () {
        onSwitch.call(!value);
      },
      child: Container(
        width: 60,
        height: 35,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
                color: CustomColor()
                    .accentColor(CatchTheme.getAccentColor())
                    .withOpacity(value ? 1 : .5),
                width: 3),
            color: value
                ? CustomColor().accentColor(CatchTheme.getAccentColor())
                : Colors.transparent),
        child: Align(
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 25,
            height: 25,
            margin: EdgeInsets.only(left: value ? 27 : 2.5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: value
                    ? CustomColor.textH1Dark
                    : isDark
                        ? CustomColor.textH2Dark
                        : CustomColor.textH2Light),
          ),
        ),
      ),
    );
  }
}
