import 'package:hive_flutter/hive_flutter.dart';

const String cartBoxName = 'cartBox';

Future<void> initCartHive() async {
  await Hive.initFlutter();
  await Hive.openBox(cartBoxName);
}

Box getCartBox() {
  return Hive.box(cartBoxName);
}
