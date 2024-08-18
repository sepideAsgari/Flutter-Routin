import 'package:flutter/material.dart';


typedef OnResult = Function(String data);

class Rute {

  static navigate(BuildContext context,Widget widget, {OnResult? onResult}){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget,)).then((value){
      onResult?.call(value.toString());
    });
  }

  static navigateClose(BuildContext context,Widget widget){
    navigateBack(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget,));
  }

  static navigateBack(BuildContext context){
    Navigator.of(context).pop();
  }

}