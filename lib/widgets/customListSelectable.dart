import 'package:flutter/material.dart';
import 'package:routine/widgets/customInkWell.dart';

import '../utils/themeManager.dart';
import 'customButton.dart';
import 'customText.dart';

typedef OnSelected = Function(int i);

class CustomListSelectable extends StatelessWidget {
  const CustomListSelectable(
      {super.key,
      required this.items,
      required this.onSelected,
      required this.selected});

  final int selected;
  final List items;
  final OnSelected onSelected;

  @override
  Widget build(BuildContext context) {
    bool isDark =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
          color: isDark ? CustomColor.itemDark : CustomColor.itemLight,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.03),
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset.zero)
          ]),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return item(selected == index ? true : false, items[index], () {
            onSelected.call(index);
          });
        },
      ),
    );
  }

  Widget item(bool selected, String name, OnClick onClick,
      {bool isColor = true}) {
    return CustomInkWell(
      onClick: onClick,
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            selected
                ? Icon(Icons.check, size: 20, color: CustomColor.green)
                : Container(),
            const Spacer(),
            CustomText(text: name, colorStyle: ColorStyle.h2, textSize: 16),
          ],
        ),
      ),
    );
  }
}
