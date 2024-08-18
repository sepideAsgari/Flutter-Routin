import 'package:flutter/material.dart';
import 'package:routine/widgets/customListSelectable.dart';
import '../utils/displaySize.dart';
import '../utils/themeManager.dart';
import 'customInkWell.dart';

class CustomColorSelectable extends StatefulWidget {
  const CustomColorSelectable(
      {super.key, required this.selected, required this.onSelected});

  final int selected;
  final OnSelected onSelected;

  @override
  State<CustomColorSelectable> createState() => _CustomColorSelectableState();
}

class _CustomColorSelectableState extends State<CustomColorSelectable> {
  final List<Color> colors = [
    CustomColor.blue,
    CustomColor.green,
    CustomColor.orange,
    CustomColor.red,
    CustomColor.purple,
    CustomColor.pink
  ];

  @override
  Widget build(BuildContext context) {
    double w = (Ds.size.width - 16) / 6;
    return SizedBox(
      height: w,
      child: ListView.builder(
        itemCount: colors.length,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          return Container(
            width: w,
            height: w,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            child: CustomInkWell(
              onClick: () {
                if (index != widget.selected) {
                  widget.onSelected.call(index);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: index == widget.selected
                          ? colors[index]
                          : colors[index].withAlpha(20),
                      width: 3),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Container(
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: colors[index],
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
