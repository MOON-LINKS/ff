import 'package:flutter/material.dart';

class CustomMenuCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;
  const CustomMenuCheckbox(
      {super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: Colors.purple,
      activeTrackColor: const Color.fromARGB(85, 155, 39, 176),
      inactiveThumbColor: Colors.blueGrey,
      inactiveTrackColor: Colors.grey,
    );
  }
}
