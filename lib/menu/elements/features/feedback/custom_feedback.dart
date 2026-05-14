import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';

class CustomFeedback extends StatefulWidget {
  final bool isEnabled;
  final bool isLocked;
  const CustomFeedback(
      {super.key, required this.isEnabled, required this.isLocked});
  @override
  State<CustomFeedback> createState() => _CustomFeedbackState();
}

class _CustomFeedbackState extends State<CustomFeedback> {
  int hoveredIndex = -1;
  int selectedIndex = 4;
  Widget buildStar(int index) {
    bool isFilled =
        hoveredIndex != -1 ? hoveredIndex >= index : selectedIndex >= index;
    return Listener(
      onPointerHover: (_) => setState(() {
        hoveredIndex = index;
      }),
      onPointerCancel: (_) => setState(() {
        hoveredIndex = -1;
      }),
      child: GestureDetector(
        onTap: () => setState(() {
          selectedIndex = index;
        }),
        child: Icon(
          isFilled ? Icons.star : Icons.star_border_outlined,
          size: 30,
          color: isFilled
              ? Colors.yellow
              : const Color.fromARGB(255, 168, 168, 168),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(20),
        child: Container(
            color: Colors.white,
            width: context.screenWidth * (context.isWide ? 0.4 : .8),
            height: 200,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Text(AppLocalizations.of(context)!.menu_add_review),
                    Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildStar(0),
                        buildStar(1),
                        buildStar(2),
                        buildStar(3),
                        buildStar(4),
                      ],
                    ),
                    FractionallySizedBox(
                        widthFactor: 0.5,
                        child: TextField(
                          enabled: false,
                          cursorColor: Colors.purple,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!
                                .menu_write_review_hint,
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.grey[400]!,
                                width: 2,
                              ),
                            ),
                          ),
                        )),
                    CustomMenuButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(AppLocalizations.of(context)!
                                  .menu_preview_notice)));
                        },
                        child: AppLocalizations.of(context)!.menu_send_review)
                  ],
                ),
                if (!widget.isEnabled)
                  Positioned.fill(
                      child: Stack(
                    children: [
                      Container(color: const Color.fromARGB(120, 155, 39, 176)),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                      widget.isLocked
                          ? Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lock_open,
                                  color: Colors.purple,
                                  size: 80,
                                ),
                                Text(
                                  AppLocalizations.of(context)!
                                      .menu_go_pro_to_unlock,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ))
                          : const SizedBox.shrink(),
                    ],
                  ))
              ],
            )));
  }
}
