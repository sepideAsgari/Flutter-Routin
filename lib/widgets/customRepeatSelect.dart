import 'package:flutter/material.dart';
import 'package:routine/utils/displaySize.dart';
import 'package:routine/utils/themeManager.dart';
import 'package:routine/widgets/customInkWell.dart';
import 'package:routine/widgets/customListSelectable.dart';
import 'package:routine/widgets/customText.dart';

class CustomRepeatSelect extends StatefulWidget {
  const CustomRepeatSelect({super.key, required this.onSelected});

  final OnSelected onSelected;

  @override
  State<CustomRepeatSelect> createState() => _CustomRepeatSelectState();
}

class _CustomRepeatSelectState extends State<CustomRepeatSelect> {
  int selected = 2;

  setSelected(int i) {
    if (selected != i) {
      setState(() {
        widget.onSelected.call(i);
        selected = i;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = (Ds.size.width - 32) / 3;
    bool isDark =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 30,
      child: Stack(
        children: [
          Positioned(
              child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: w,
            height: 30,
            margin: EdgeInsets.only(left: selected * w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: isDark ? CustomColor.itemDark : CustomColor.itemLight),
          )),
          Positioned(
              child: Row(
            children: [
              item(0, 'ماهانه'),
              item(1, 'هفتگی'),
              item(2, 'روزانه'),
            ],
          )),
        ],
      ),
    );
  }

  Widget item(int index, String name) {
    return Expanded(
        child: CustomInkWell(
      onClick: () {
        setSelected(index);
      },
      child: Align(
        alignment: Alignment.center,
        child: CustomText(
          text: name,
          colorStyle: index == selected ? ColorStyle.h1 : ColorStyle.h2,
          textSize: 16,
          textAlign: TextAlign.center,
        ),
      ),
    ));
  }
}
