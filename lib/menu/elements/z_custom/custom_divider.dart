import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        Divider(
            color: const Color.fromARGB(150, 255, 255, 255),
            height: 5,
            thickness: 5),
        const SizedBox(height: 50),
      ],
    );
  }
}
