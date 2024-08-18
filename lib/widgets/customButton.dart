import 'package:flutter/material.dart';

import '../utils/themeManager.dart';
import 'customText.dart';

typedef OnClick = Function();

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.width,
    required this.height,
    required this.edgeInsets,
    required this.text,
    required this.onClick,
  });

  final double width;
  final double height;
  final EdgeInsets edgeInsets;
  final String text;
  final OnClick onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: edgeInsets,
      child: InkWell(
        onTap: () {
          onClick.call();
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: CustomColor().accentColor(CatchTheme.getAccentColor())),
          child: CustomText(
            text: text,
            textSize: 20,
            colorStyle: ColorStyle.h1,
            textAlign: TextAlign.center,
            color: CustomColor.textH1Dark,
          ),
        ),
      ),
    );
  }
}
