import 'package:hive_flutter/hive_flutter.dart';

const String localeBoxName = 'localeLanguages';

Future<void> initLocaleHive() async {
  await Hive.initFlutter();
  await Hive.openBox(localeBoxName);
}

Box getLocaleBox() {
  return Hive.box(localeBoxName);
}
