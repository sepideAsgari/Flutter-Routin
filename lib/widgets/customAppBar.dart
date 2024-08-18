import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routine/utils/customRute.dart';
import 'package:routine/utils/themeManager.dart';
import 'package:routine/widgets/customText.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.name, required this.widgets});

  final String name;
  final List<Widget> widgets;

  @override
  Widget build(BuildContext context) {
    bool isDark =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Row(
            children: widgets,
          ),
          const Spacer(),
          Hero(
            tag: 'appbartext',
            child: CustomText(
              text: name,
              colorStyle: ColorStyle.h1,
              textSize: 20,
            ),
          ),
          IconButton(
              onPressed: () {
                Rute.navigateBack(context);
              },
              icon: Icon(Icons.arrow_forward_rounded,
                  color: isDark
                      ? CustomColor.textH1Dark
                      : CustomColor.textH1Light))
        ],
      ),
    );
  }
}
