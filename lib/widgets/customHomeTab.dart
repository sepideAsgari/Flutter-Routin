import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine/widgets/customListSelectable.dart';

import '../utils/themeManager.dart';
import 'customInkWell.dart';
import 'customText.dart';

class CustomHomeTab extends StatefulWidget {
  const CustomHomeTab(
      {super.key, required this.onSelected, required this.tabSelected});

  final int tabSelected;
  final OnSelected onSelected;

  @override
  State<CustomHomeTab> createState() => _CustomHomeTabState();
}

class _CustomHomeTabState extends State<CustomHomeTab> {
  List<String> item = ['امروز', 'هفتگی', 'نمای کلی'];

  @override
  Widget build(BuildContext context) {
    bool isDark =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 16),
      height: 40,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: item.length,
        reverse: true,
        itemBuilder: (context, index) {
          return CustomInkWell(
            onClick: () {
              if (index != widget.tabSelected) {
                setState(() {
                  widget.onSelected.call(index);
                });
              }
            },
            child: Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 0),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: widget.tabSelected == index
                      ? isDark
                          ? CustomColor.itemDark
                          : CustomColor.itemLight
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: widget.tabSelected == index
                            ? Colors.black.withOpacity(.03)
                            : Colors.transparent,
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset.zero)
                  ]),
              child: Align(
                alignment: Alignment.center,
                child: CustomText(
                  text: item[index],
                  colorStyle: widget.tabSelected == index
                      ? ColorStyle.h1
                      : ColorStyle.h3,
                  textSize: 16,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
