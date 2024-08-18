import 'package:hive_flutter/hive_flutter.dart';

class Subscribe {
  static init() async {
    await Hive.openBox('subscribe');
  }

  static getSubscribe() {
    return Hive.box('subscribe').get('subscribe', defaultValue: false);
  }

  static updateSubscribe(bool b) {
    Hive.box('subscribe').put('subscribe', b);
  }
}
