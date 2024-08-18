import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:routine/utils/themeManager.dart';
import 'package:routine/widgets/customText.dart';

typedef OnCallBack = Function(String time);

class CustomNumberPickerDialog {
  static show(BuildContext context, OnCallBack onCallBack) {
    bool isDark =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isDark ? CustomColor.itemDark : CustomColor.itemLight,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: isDark
                        ? CustomColor.textH2Dark
                        : CustomColor.textH2Light),
                margin: const EdgeInsets.symmetric(vertical: 16),
              ),
              CustomNumberPickerDialogItem(onCallBack: onCallBack)
            ],
          ),
        );
      },
    );
  }
}

class CustomNumberPickerDialogItem extends StatefulWidget {
  const CustomNumberPickerDialogItem({super.key, required this.onCallBack});

  final OnCallBack onCallBack;

  @override
  State<CustomNumberPickerDialogItem> createState() =>
      _CustomNumberPickerDialogItemState();
}

class _CustomNumberPickerDialogItemState
    extends State<CustomNumberPickerDialogItem> {
  int _currentValue = 0;
  int _currentValue2 = 0;

  callBack() {
    String time = '';
    time += _currentValue.toString().length < 2
        ? '0$_currentValue'
        : _currentValue.toString();
    time += ':';
    time += _currentValue2.toString().length < 2
        ? '0$_currentValue2'
        : _currentValue2.toString();
    widget.onCallBack.call(time);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NumberPicker(
          value: _currentValue,
          minValue: 0,
          maxValue: 23,
          itemHeight: 40,
          itemWidth: 70,
          selectedTextStyle: TextStyle(
              fontSize: 24,
              color: CustomColor().accentColor(CatchTheme.getAccentColor())),
          axis: Axis.vertical,
          infiniteLoop: true,
          textMapper: (numberText) {
            if (numberText.length < 2) {
              numberText = '0$numberText';
            }
            return numberText;
          },
          onChanged: (value) {
            setState(() {
              _currentValue = value;
              callBack();
            });
          },
        ),
        CustomText(text: ':', colorStyle: ColorStyle.h1),
        NumberPicker(
          value: _currentValue2,
          minValue: 0,
          maxValue: 59,
          itemWidth: 70,
          itemHeight: 40,
          selectedTextStyle: TextStyle(
              fontSize: 24,
              color: CustomColor().accentColor(CatchTheme.getAccentColor())),
          infiniteLoop: true,
          axis: Axis.vertical,
          textMapper: (numberText) {
            if (numberText.length < 2) {
              numberText = '0$numberText';
            }
            return numberText;
          },
          onChanged: (value) {
            setState(() {
              _currentValue2 = value;
              callBack();
            });
          },
        )
      ],
    );
  }
}
