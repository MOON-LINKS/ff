import 'package:flutter/material.dart';

extension ScreenExt on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isWide => screenWidth > 1200;
}
