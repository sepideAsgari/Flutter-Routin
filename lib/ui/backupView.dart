import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:routine/widgets/customButton.dart';
import 'package:routine/widgets/customText.dart';

import '../utils/themeManager.dart';
import '../widgets/customAppBar.dart';

class BackupView extends StatefulWidget {
  const BackupView({super.key});

  @override
  State<BackupView> createState() => _BackupViewState();
}

class _BackupViewState extends State<BackupView> {
  @override
  Widget build(BuildContext context) {
    bool isDark =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const CustomAppBar(name: 'پشتیبان گیری', widgets: []),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: isDark ? CustomColor.itemDark : CustomColor.itemLight,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const CustomText(
                    text: 'ذخیره نسخه پشتیبانی در فایل های شما',
                    colorStyle: ColorStyle.h2),
                CustomButton(
                  width: double.infinity,
                  height: 40,
                  edgeInsets: const EdgeInsets.only(top: 16),
                  text: 'ذخیره',
                  onClick: () {
                    Fluttertoast.showToast(
                        msg: "به زودی",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 16.0);
                  },
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? CustomColor.itemDark : CustomColor.itemLight,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const CustomText(
                    text: 'بارگذاری نسخه پشتیبانی از فایل',
                    colorStyle: ColorStyle.h2),
                CustomButton(
                  width: double.infinity,
                  height: 40,
                  edgeInsets: const EdgeInsets.only(top: 16),
                  text: 'بارگذاری',
                  onClick: () {
                    Fluttertoast.showToast(
                        msg: "به زودی",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 16.0);
                  },
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
