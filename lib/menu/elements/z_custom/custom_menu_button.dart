import 'package:flutter/material.dart';

class CustomMenuButton extends StatelessWidget {
  final String child;
  final VoidCallback onPressed;
  final double? fontSize;
  final FontWeight? fontWeight;
  const CustomMenuButton(
      {super.key,
      required this.child,
      required this.onPressed,
      this.fontSize,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(30))),
        child: Text(
          child.toUpperCase(),
          style: TextStyle(
              color: Colors.white,
              fontWeight: fontWeight ?? FontWeight.w400,
              fontSize: fontSize ?? 16),
        ));
  }
}
