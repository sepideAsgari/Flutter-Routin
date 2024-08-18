import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine/widgets/customInkWell.dart';
import 'package:routine/widgets/customText.dart';

import '../utils/displaySize.dart';
import '../utils/themeManager.dart';
import 'customMonthSelected.dart';

class CustomWeekSelected extends StatefulWidget {
  const CustomWeekSelected(
      {super.key, required this.onDaySelect, required this.number});

  final int number;
  final OnDaySelect onDaySelect;

  @override
  State<CustomWeekSelected> createState() => _CustomWeekSelectedState();
}

class _CustomWeekSelectedState extends State<CustomWeekSelected> {
  int number = 1;

  @override
  void initState() {
    if (widget.number != 0) {
      number = widget.number;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = (Ds.size.width - 32) / 7;
    return Container(
      height: w + 16,
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          Container(
            width: w,
            height: w,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            margin: EdgeInsets.only(right: 8),
            child: CustomInkWell(
              onClick: () {
                if (number < 7) {
                  setState(() {
                    number++;
                  });
                  widget.onDaySelect.call(number.toString());
                }
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: CustomColor()
                        .accentColor(CatchTheme.getAccentColor())
                        .withOpacity(number == 7 ? .1 : .4),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.03),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset.zero)
                    ]),
                child: Icon(
                  Icons.add,
                  color: CustomColor()
                      .accentColor(CatchTheme.getAccentColor())
                      .withOpacity(number == 7 ? .5 : 1),
                ),
              ),
            ),
          ),
          CustomText(
            text: number.toString(),
            colorStyle: ColorStyle.h1,
            textSize: 18,
          ),
          Container(
            width: w,
            height: w,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            margin: EdgeInsets.only(left: 8),
            child: CustomInkWell(
              onClick: () {
                if (number > 1) {
                  setState(() {
                    number--;
                  });
                  widget.onDaySelect.call(number.toString());
                }
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: CustomColor()
                        .accentColor(CatchTheme.getAccentColor())
                        .withOpacity(number == 1 ? .1 : .4),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.03),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset.zero)
                    ]),
                child: Icon(
                  Icons.remove,
                  color: CustomColor()
                      .accentColor(CatchTheme.getAccentColor())
                      .withOpacity(number == 1 ? .5 : 1),
                ),
              ),
            ),
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomText(
                text: 'روز های هفته',
                colorStyle: ColorStyle.h2,
                textSize: 16,
              ),
              CustomText(
                text: number == 7 ? 'هر روز هفته' : '${number} روز در هفته',
                colorStyle: ColorStyle.h3,
                textSize: 14,
              )
            ],
          )
        ],
      ),
    );
  }
}
