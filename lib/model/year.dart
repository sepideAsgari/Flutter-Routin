import 'package:hive_flutter/hive_flutter.dart';

part 'year.g.dart';

@HiveType(typeId: 1)
class Year {
  @HiveField(0)
  int id;
  @HiveField(1)
  List<List<int>> mount = [[], [], [], [], [], [], [], [], [], [], [], []];

  Year(this.id);
}
