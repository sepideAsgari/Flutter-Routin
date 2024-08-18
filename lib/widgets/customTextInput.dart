import 'package:flutter/material.dart';

import '../utils/themeManager.dart';

class CustomTextInput extends StatefulWidget {
  const CustomTextInput({
    super.key,
    required this.textEditingController,
    this.width = 100,
    this.height = 50,
    this.edgeInsets = EdgeInsets.zero,
    this.hint = '',
    this.password = false,
    required this.dark,
  });

  final TextEditingController textEditingController;
  final double width;
  final double height;
  final EdgeInsets edgeInsets;
  final String hint;
  final bool password;
  final bool dark;

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.edgeInsets,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: widget.dark ? CustomColor.itemDark : CustomColor.itemLight,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.03),
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset.zero)
          ]),
      child: TextField(
        controller: widget.textEditingController,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        maxLines: 1,
        keyboardAppearance: ThemeData().brightness,
        cursorRadius: const Radius.circular(5),
        cursorColor: CustomColor.green,
        keyboardType:
            widget.password ? TextInputType.number : TextInputType.text,
        style: TextStyle(
            color:
                widget.dark ? CustomColor.textH1Dark : CustomColor.textH1Dark,
            fontSize: 18,
            fontWeight: FontWeight.w400),
        decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
                height: 1.3,
                color: widget.dark
                    ? CustomColor.textH3Dark
                    : CustomColor.textH3Light,
                fontSize: 18,
                fontWeight: FontWeight.w400),
            border: InputBorder.none,
            counter: const SizedBox(),
            disabledBorder: InputBorder.none),
      ),
    );
  }
}
