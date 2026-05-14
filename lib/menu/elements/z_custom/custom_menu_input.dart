import 'package:flutter/material.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_tooltip.dart';

class CustomMenuInput extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? function;
  final String? tooltipMessage;
  final String hintText;
  final String? Function(String?)? validator;

  const CustomMenuInput(
      {super.key,
      required this.controller,
      required this.function,
      required this.hintText,
      this.tooltipMessage,
      this.validator});
  @override
  State<CustomMenuInput> createState() => _CustomMenuInputState();
}

class _CustomMenuInputState extends State<CustomMenuInput> {
  final FocusNode _focusNode = FocusNode();
  bool isFocused = false;
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: const TextSelectionThemeData(
            selectionColor: Colors.purple,
            selectionHandleColor: Colors.purple,
            cursorColor: Colors.purple,
          ),
        ),
        child: SizedBox(
            width: 250,
            child: TextFormField(
              validator: widget.validator,
              controller: widget.controller,
              cursorColor: Colors.purple,
              focusNode: _focusNode,
              style: TextStyle(color: isFocused ? Colors.white : Colors.black),
              decoration: InputDecoration(
                  hintText: widget.hintText,
                  filled: true,
                  fillColor: isFocused ? Colors.black : Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide: BorderSide(color: Colors.purple, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide: BorderSide(color: Colors.purple, width: 2)),
                  suffixIcon: widget.tooltipMessage != null
                      ? CustomMenuTooltip(message: widget.tooltipMessage!)
                      : null),
              onChanged: widget.function,
            )));
  }
}
