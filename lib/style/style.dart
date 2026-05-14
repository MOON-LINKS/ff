import 'package:flutter/material.dart';

TextStyle appTextStyle({
  Color? color,
  double fontSize = 16,
  FontWeight fontWeight = FontWeight.normal,
  FontStyle fontStyle = FontStyle.normal,
  double letterSpacing = 0,
  double wordSpacing = 0,
  TextDecoration decoration = TextDecoration.none,
}) {
  return TextStyle(
    color: color ?? Colors.white,
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    decoration: decoration,
  );
}

double getResponsivePadding(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  if (width >= 1700) return 700;
  if (width >= 990) return 500;
  if (width >= 600) return 80;
  return 10;
}
