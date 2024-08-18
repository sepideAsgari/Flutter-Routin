import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine/widgets/customInkWell.dart';
import 'package:routine/widgets/customText.dart';

import '../utils/displaySize.dart';
import '../utils/themeManager.dart';

typedef OnDaySelect = Function(String days);

class CustomMonthSelected extends StatefulWidget {
  const CustomMonthSelected(
      {super.key, required this.onDaySelect, required this.selected});

  final String selected;
  final OnDaySelect onDaySelect;

  @override
  State<CustomMonthSelected> createState() => _CustomMonthSelectedState();
}

class _CustomMonthSelectedState extends State<CustomMonthSelected> {
  List selected = [0];

  String getSelectString() {
    String select = '';
    selected.map((e) {
      select += '${e + 1},';
    }).toList();
    return select.substring(0, select.length - 1);
  }

  @override
  void initState() {
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
    double w = (Ds.size.width - 32);
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomText(
              text: 'هر ماه روز های ${getSelectString()}',
              colorStyle: ColorStyle.h2,
              textSize: 16),
          Container(
            width: w,
            height: ((w / 7) * 5) + 8,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
                color: isDark ? CustomColor.itemDark : CustomColor.itemLight,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.03),
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: Offset.zero)
                ]),
            child: GridView.builder(
              itemCount: 31,
              padding: const EdgeInsets.all(8),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7),
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(4),
                  child: CustomInkWell(
                    onClick: () {
                      if (selected.contains(index)) {
                        setState(() {
                          if (selected.length > 1) {
                            selected.remove(index);
                          }
                        });
                      } else {
                        setState(() {
                          selected.add(index);
                        });
                      }
                      widget.onDaySelect.call(getSelectString());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: selected.contains(index)
                              ? CustomColor()
                                  .accentColor(CatchTheme.getAccentColor())
                              : Colors.transparent),
                      child: CustomText(
                        text: '${index + 1}',
                        colorStyle: ColorStyle.h2,
                        color: selected.contains(index)
                            ? CustomColor.textH1Dark
                            : null,
                        textSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
