import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/themeManager.dart';

enum ColorStyle { h1, h2, h3 }

class ColorStyleUse {
  static FontWeight getFontWeight(bool isDark, ColorStyle colorStyle) {
    FontWeight fontWeight = FontWeight.normal;
    if (isDark) {
      switch (colorStyle) {
        case ColorStyle.h1:
          fontWeight = FontWeight.w700;
        case ColorStyle.h2:
          fontWeight = FontWeight.normal;
        case ColorStyle.h3:
          fontWeight = FontWeight.w700;
      }
    } else {
      switch (colorStyle) {
        case ColorStyle.h1:
          fontWeight = FontWeight.w700;
        case ColorStyle.h2:
          fontWeight = FontWeight.normal;
        case ColorStyle.h3:
          fontWeight = FontWeight.w700;
      }
    }
    return fontWeight;
  }

  static Color getColorStyle(bool isDark, ColorStyle colorStyle) {
    Color color = Colors.black;
    if (isDark) {
      switch (colorStyle) {
        case ColorStyle.h1:
          color = CustomColor.textH1Dark;
        case ColorStyle.h2:
          color = CustomColor.textH2Dark;
        case ColorStyle.h3:
          color = CustomColor.textH3Dark;
      }
    } else {
      switch (colorStyle) {
        case ColorStyle.h1:
          color = CustomColor.textH1Light;
        case ColorStyle.h2:
          color = CustomColor.textH2Light;
        case ColorStyle.h3:
          color = CustomColor.textH3Light;
      }
    }
    return color;
  }
}

class CustomText extends StatelessWidget {
  const CustomText(
      {super.key,
      required this.text,
      this.color,
      this.textSize = 18,
      required this.colorStyle,
      this.textAlign = TextAlign.right});

  final String text;
  final Color? color;
  final double textSize;
  final TextAlign textAlign;
  final ColorStyle colorStyle;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeThemeNotifier>(
      builder: (context, value, child) {
        return Text(
          text,
          textAlign: textAlign,
          textDirection: TextDirection.rtl,
          style: TextStyle(
              color: color ??
                  ColorStyleUse.getColorStyle(value.isDark, colorStyle),
              fontSize: textSize,
              fontWeight:
                  ColorStyleUse.getFontWeight(value.isDark, colorStyle)),
        );
      },
    );
  }
}
