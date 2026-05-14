import 'package:flutter/material.dart';
import 'package:moonlinks/functions/context_extension.dart';

class CustomGoogleAcc extends StatefulWidget {
  final String? mainAcc;
  final Function(String) onChange;
  const CustomGoogleAcc(
      {super.key, required this.mainAcc, required this.onChange});

  @override
  State<CustomGoogleAcc> createState() => _CustomGoogleAccState();
}

class _CustomGoogleAccState extends State<CustomGoogleAcc> {
  String value = '';
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    value = widget.mainAcc ?? '';
    _controller = TextEditingController(text: value);
  }

  @override
  void didUpdateWidget(covariant CustomGoogleAcc oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mainAcc != oldWidget.mainAcc) {
      value = widget.mainAcc ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth * (context.isWide ? .4 : .8),
      child: TextField(
        controller: _controller,
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.purple,
        decoration: InputDecoration(
            hint: Text(
              'https://maps.google.com/',
              style: TextStyle(color: Colors.white70),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.purple, width: 2))),
        onChanged: (value) {
          widget.onChange(value);
        },
      ),
    );
  }
}
