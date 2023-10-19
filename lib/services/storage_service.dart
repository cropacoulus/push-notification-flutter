import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  Box getHiveBox(String name) {
    return Hive.box(name);
  }

  Future<Box> initHiveBox(String name) {
    return Hive.openBox(name);
  }

  Future initHiveStorage() {
    return Hive.initFlutter();
  }
}
