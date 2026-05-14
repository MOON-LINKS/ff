import 'package:flutter/material.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_tooltip.dart';

class CustomTitleSection extends StatelessWidget {
  final String title;
  final String toolTip;
  final int margin;
  const CustomTitleSection(
      {super.key,
      required this.title,
      required this.toolTip,
      required this.margin});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: CustomMenuTitle(child: title),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: MediaQuery.of(context).size.width / 2 - margin,
          child: CustomMenuTooltip(
            message: toolTip,
          ),
        ),
      ],
    );
  }
}
