import 'package:flutter/material.dart';

class CustomMenuTooltip extends StatelessWidget {
  final String message;
  const CustomMenuTooltip({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
        message: message,
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Icon(
            Icons.info_outline,
            color: const Color.fromARGB(255, 210, 60, 236),
          ),
        ));
  }
}
