import 'package:flutter/material.dart';
import 'package:routine/widgets/customButton.dart';

class CustomInkWell extends StatelessWidget {
  const CustomInkWell({super.key, required this.onClick, required this.child});

  final OnClick onClick;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: onClick,
      child: child,
    );
  }
}
