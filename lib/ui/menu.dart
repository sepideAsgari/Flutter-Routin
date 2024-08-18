import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:routine/ui/settings.dart';
import 'package:routine/ui/subscribeView.dart';
import 'package:routine/utils/customRute.dart';
import 'package:routine/widgets/customAppBar.dart';
import 'package:routine/widgets/customButton.dart';
import 'package:routine/widgets/customIcon.dart';
import 'package:routine/widgets/customInkWell.dart';
import 'package:routine/widgets/customText.dart';

import '../utils/themeManager.dart';
import 'backupView.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  PackageInfo? packageInfo;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(name: 'منو', widgets: []),
            // groupItems(items: [
            //   item(PngIcon.premium, 'نسخه طلایی', () {
            //     Rute.navigate(context, const SubscribeView());
            //   }, isColor: false),
            // ]),
            groupItems(items: [
              item(PngIcon.settings, 'تنظیمات', () {
                Rute.navigate(context, const Settings());
              }),
              // item(PngIcon.chart, 'نمودار', () {
              //   Fluttertoast.showToast(
              //       msg: "به زودی",
              //       toastLength: Toast.LENGTH_SHORT,
              //       gravity: ToastGravity.BOTTOM,
              //       timeInSecForIosWeb: 1,
              //       backgroundColor: Colors.white,
              //       textColor: Colors.black,
              //       fontSize: 16.0);
              // }),
              // item(PngIcon.backup, 'پشتیبان گیری', () {
              //   Rute.navigate(context, const BackupView());
              // }),
            ]),
            groupItems(items: [
              // item(PngIcon.star, 'ثبت امتیاز', () {}),
              item(PngIcon.telegram, 'تلگرام', () {}),
              item(PngIcon.instagram, 'اینستاگرام', () {}),
            ]),
            groupItems(items: [
              item(PngIcon.pap, 'حریم خصوصی و امنیت', () {}),
            ]),
            const SizedBox(
              height: 8,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: CustomText(
                text: packageInfo?.version ?? '1.0.0',
                textSize: 14,
                colorStyle: ColorStyle.h2,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget groupItems({required List<Widget> items}) {
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: items,
      ),
    );
  }

  Widget item(String icon, String name, OnClick onClick,
      {bool isColor = true}) {
    bool isDark =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    return CustomInkWell(
      onClick: onClick,
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(Icons.arrow_back_ios_rounded,
                size: 18,
                color:
                    isDark ? CustomColor.textH3Dark : CustomColor.textH3Light),
            const Spacer(),
            Hero(
                tag: 'appbartext',
                child: CustomText(
                    text: name, colorStyle: ColorStyle.h2, textSize: 16)),
            const SizedBox(
              width: 16,
            ),
            CustomIconButton(
                pngIcon: icon,
                accent: true,
                colorStyle: ColorStyle.h2,
                isColor: isColor)
          ],
        ),
      ),
    );
  }
}
