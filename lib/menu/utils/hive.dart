import 'package:hive_flutter/hive_flutter.dart';

const String menuBoxName = 'menuBox';

Future<void> initMenuHive() async {
  await Hive.initFlutter();
  await Hive.openBox(menuBoxName);
}

Box getMenuBox() {
  return Hive.box(menuBoxName);
}

Future<void> saveMenuData(String key, dynamic value) async {
  var box = getMenuBox();
  await box.put(key, value);
}

dynamic getMenuData(String key) {
  var box = getMenuBox();
  return box.get(key);
}

/* Future<void> deleteMenuData(String key) async {
  var box = getMenuBox();
  await box.delete(key);
}
 */
