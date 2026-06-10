import 'package:hive_flutter/hive_flutter.dart';

const String catalogueBox = 'catalogueBox';

Future<void> initCatalogueHive() async {
  await Hive.initFlutter();
  await Hive.openBox(catalogueBox);
}

Box getCatalogueBox() {
  return Hive.box(catalogueBox);
}

Future<void> saveCatalogueData(String key, dynamic value) async {
  var box = getCatalogueBox();
  await box.put(key, value);
}

dynamic getCatalogueData(String key) {
  var box = getCatalogueBox();
  return box.get(key);
}
