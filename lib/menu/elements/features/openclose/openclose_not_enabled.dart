import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_checkbox.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';

class OpencloseNotEnabled extends StatefulWidget {
  const OpencloseNotEnabled({super.key});

  @override
  State<OpencloseNotEnabled> createState() => _OpencloseNotEnabledState();
}

class _OpencloseNotEnabledState extends State<OpencloseNotEnabled> {
  final hours = [
    {
      'day': 'Monday',
      'from': null,
      'to': null,
    },
    {
      'day': 'Tuesday',
      'from': null,
      'to': null,
    },
    {
      'day': 'Wednesday',
      'from': null,
      'to': null,
    },
    {
      'day': 'Thursday',
      'from': null,
      'to': null,
    },
    {
      'day': 'Friday',
      'from': null,
      'to': null,
    },
    {
      'day': 'Saturday',
      'from': null,
      'to': null,
    },
    {
      'day': 'Sunday',
      'from': null,
      'to': null,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTitleSection(
          margin: 150,
          title: AppLocalizations.of(context)!.menu_open_close_hours_title,
          toolTip: AppLocalizations.of(context)!.menu_open_close_hours_tooltip,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CustomMenuCheckbox(value: false, onChanged: (val) {})],
        ),
        const SizedBox(height: 10),
        ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(20),
            child: Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    Column(
                      children: hours.asMap().entries.map((entry) {
                        final LinkedHashMap<dynamic, dynamic> dayInfo =
                            entry.value as LinkedHashMap<dynamic, dynamic>;

                        return Card(
                            margin: EdgeInsets.all(5),
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Center(
                                          child: Text(
                                        dayInfo['day'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ))),
                                  Expanded(
                                    flex: 1,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        AppLocalizations.of(context)!.menu_from,
                                        style: const TextStyle(
                                            color: Colors.purple,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        AppLocalizations.of(context)!.menu_to,
                                        style: const TextStyle(
                                            color: Colors.purple,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      }).toList(),
                    ),
                    Positioned.fill(
                        child: Stack(
                      children: [
                        Container(
                          color: const Color.fromARGB(120, 155, 39, 176),
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color: Colors.transparent,
                          ),
                        ),
                        Center(
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
                      ],
                    ))
                  ],
                ))),
      ],
    );
  }
}
