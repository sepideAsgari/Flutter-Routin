import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine/widgets/customInkWell.dart';
import 'package:routine/widgets/customText.dart';

import '../utils/displaySize.dart';
import '../utils/themeManager.dart';
import 'customMonthSelected.dart';

class CustomDaySelected extends StatefulWidget {
  const CustomDaySelected(
      {super.key, required this.onDaySelect, required this.selected});

  final String selected;
  final OnDaySelect onDaySelect;

  @override
  State<CustomDaySelected> createState() => _CustomDaySelectedState();
}

class _CustomDaySelectedState extends State<CustomDaySelected> {
  List selected = [0, 1, 2, 3, 4, 5, 6];
  List days = ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج'];

  @override
  initState() {
    if (widget.selected.isNotEmpty) {
      List select = [];
      selected = [];
      if (widget.selected.length > 1) {
        select = widget.selected.split(',');
      } else {
        select.add(widget.selected.toString());
      }
      select.map((e) {
        selected.add(int.parse(e));
      }).toList();
    }
    super.initState();
    init();
  }

  String getSelectString() {
    String select = '';
    selected.map((e) {
      if (selected.length > 1) {
        select += '${e + 1},';
      } else {
        select += '${e + 1}';
      }
    }).toList();
    return selected.length > 1
        ? select.substring(0, select.length - 1)
        : select;
  }

  init() {
    Future.delayed(
      Duration.zero,
      () {
        widget.onDaySelect.call(getSelectString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    double w = (Ds.size.width - 32) / 7;
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, right: 16, left: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const CustomText(
              text: 'روز های', colorStyle: ColorStyle.h2, textSize: 20),
          Container(
            height: w,
            margin: EdgeInsets.only(top: 8),
            child: ListView.builder(
              reverse: true,
              itemCount: days.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: w,
                  height: w,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(6),
                  child: CustomInkWell(
                    onClick: () {
                      setState(() {
                        if (selected.contains(index)) {
                          if (selected.length > 1) {
                            selected.remove(index);
                          }
                        } else {
                          selected.add(index);
                        }
                      });
                      widget.onDaySelect.call(getSelectString());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: selected.contains(index)
                              ? CustomColor()
                                  .accentColor(CatchTheme.getAccentColor())
                              : isDark
                                  ? CustomColor.itemDark
                                  : CustomColor.itemLight,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.03),
                                blurRadius: 5,
                                spreadRadius: 1,
                                offset: Offset.zero)
                          ]),
                      child: CustomText(
                        text: days.elementAt(index),
                        colorStyle: selected.contains(index)
                            ? ColorStyle.h1
                            : ColorStyle.h2,
                        textSize: 16,
                        color: selected.contains(index)
                            ? CustomColor.textH1Dark
                            : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
