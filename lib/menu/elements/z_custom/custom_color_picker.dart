import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:moonlinks/l10n/app_localizations.dart';

class CustomColorPicker extends StatefulWidget {
  final String text;
  final int? color;
  final Function(int) newColor;
  const CustomColorPicker(
      {super.key,
      required this.text,
      required this.color,
      required this.newColor});

  @override
  State<CustomColorPicker> createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  late int colorPicked;
  @override
  void initState() {
    super.initState();
    colorPicked = widget.color ?? 4294967295;
  }

  @override
  void didUpdateWidget(covariant CustomColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.color != widget.color && widget.color != null) {
      setState(() {
        colorPicked = widget.color!;
      });
    }
  }

  void changeColor() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(AppLocalizations.of(context)!.menu_pick_color),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: Color(colorPicked),
                  onColorChanged: (color) {
                    final opaqueColor = color.withOpacity(1.0);
                    setState(() {
                      colorPicked = opaqueColor.toARGB32();
                      widget.newColor(colorPicked);
                    });
                  },
                  enableAlpha: false,
                  labelTypes: [],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.close,
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
                color: Color(colorPicked),
                border: BoxBorder.all(color: Colors.white),
                borderRadius: BorderRadius.circular(30)),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12))),
              onPressed: changeColor,
              child: Icon(
                Icons.loop_sharp,
                color: Colors.white,
              )),
          Text(
            widget.text.toUpperCase(),
            style: TextStyle(color: Colors.white, fontSize: 14),
          )
        ],
      ),
    );
  }
}
