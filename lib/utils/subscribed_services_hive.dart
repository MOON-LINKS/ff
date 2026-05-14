import 'package:hive_flutter/hive_flutter.dart';

const String subscribedServicesBoxName = 'subscribedServices';

Future<void> initsubServicesHive() async {
  await Hive.initFlutter();
  await Hive.openBox(subscribedServicesBoxName);
}

Box getSubServicesBox() {
  return Hive.box(subscribedServicesBoxName);
}
