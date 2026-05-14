import 'package:flutter/material.dart';

class CustomMenuTitle extends StatelessWidget {
  final String child;
  const CustomMenuTitle({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(bottom: BorderSide(color: Colors.purple, width: 2)),
        ),
        child: Text(
          child.toUpperCase(),
          style: TextStyle(color: Colors.white, fontSize: 18),
        ));
  }
}
