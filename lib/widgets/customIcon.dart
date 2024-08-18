import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routine/utils/themeManager.dart';
import 'customButton.dart';
import 'customInkWell.dart';
import 'customText.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key,
      required this.pngIcon,
      required this.accent,
      this.onClick,
      required this.colorStyle,
      this.isColor = true});

  final String pngIcon;
  final bool accent;
  final ColorStyle colorStyle;
  final OnClick? onClick;
  final bool isColor;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeThemeNotifier>(
      builder: (context, value, child) {
        Color color = ColorStyleUse.getColorStyle(value.isDark, colorStyle);
        if (accent) {
          color =
              CustomColor().accentColor(value.getAccentColor).withAlpha(150);
        }
        return CustomInkWell(
          onClick: onClick ?? () {},
          child: Container(
            width: 35,
            height: 35,
            padding: EdgeInsets.all(pngIcon.contains(PngIcon.add) ? 7 : 5),
            alignment: Alignment.center,
            child: isColor
                ? Image.asset(pngIcon, fit: BoxFit.cover, color: color)
                : Image.asset(pngIcon, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
