import 'package:flutter/material.dart';

import '../utils/themeManager.dart';
import '../widgets/customAppBar.dart';
import '../widgets/customButton.dart';
import '../widgets/customIcon.dart';
import '../widgets/customInkWell.dart';
import '../widgets/customText.dart';

class SubscribeView extends StatefulWidget {
  const SubscribeView({super.key});

  @override
  State<SubscribeView> createState() => _SubscribeViewState();
}

class _SubscribeViewState extends State<SubscribeView> {
  @override
  Widget build(BuildContext context) {
    bool isDark =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const CustomAppBar(name: 'نسخه طلایی', widgets: []),
          title('از امکانات جداب و کاربردی با خرید نسخه طلایی استفاده کنید '),
          Container(
            margin: const EdgeInsets.only(right: 16, left: 16, top: 16),
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
            child: Column(
              children: [
                item(PngIcon.chart, 'آنالیز حرفه ای'),
                item(PngIcon.backup, 'پشتیبان گیری'),
                item(PngIcon.color, 'رنگ های بیشتر'),
                item(PngIcon.reorder, 'نمایش سالانه'),
                item(PngIcon.todo, 'ثبت یادداشت برای هر روز'),
                item(PngIcon.habit, 'اضافه کردن هدف به عادت'),
                item(PngIcon.star, 'قرار ها'),
              ],
            ),
          ),
          // Spacer(),
          CustomButton(
            width: double.infinity,
            height: 50,
            edgeInsets: const EdgeInsets.all(16),
            text: 'به زودی',
            onClick: () {},
          ),
        ],
      )),
    );
  }

  Widget item(String icon, String name) {
    bool isDark =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check, size: 18, color: CustomColor.green),
          const Spacer(),
          CustomText(text: name, colorStyle: ColorStyle.h2, textSize: 16),
          const SizedBox(
            width: 16,
          ),
          CustomIconButton(
              pngIcon: icon,
              accent: true,
              colorStyle: ColorStyle.h2,
              isColor: true)
        ],
      ),
    );
  }

  Widget title(String name) {
    return Container(
      height: 30,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 8),
      alignment: Alignment.centerRight,
      child: CustomText(text: name, colorStyle: ColorStyle.h1, textSize: 16),
    );
  }
}
