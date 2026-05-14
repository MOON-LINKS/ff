import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';

class AnalyticsNotEnabled extends StatefulWidget {
  const AnalyticsNotEnabled({super.key});

  @override
  State<AnalyticsNotEnabled> createState() => _AnalyticsNotEnabledState();
}

class _AnalyticsNotEnabledState extends State<AnalyticsNotEnabled> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTitleSection(
          margin: 100,
          title: AppLocalizations.of(context)!.menu_analytics_title,
          toolTip: AppLocalizations.of(context)!.menu_analytics_tooltip,
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(20),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.white),
                width: context.screenWidth * (context.isWide ? 0.5 : 0.8),
                height: 200,
              ),
              Positioned.fill(
                  child: Stack(
                children: [
                  Container(color: const Color.fromARGB(120, 155, 39, 176)),
                  BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(color: Colors.transparent)),
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
                                .menu_go_premium_to_unlock,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          )
                        ]),
                  )
                ],
              ))
            ],
          ),
        )
      ],
    );
  }
}
