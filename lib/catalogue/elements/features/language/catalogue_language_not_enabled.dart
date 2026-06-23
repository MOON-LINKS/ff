import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';

class CatalogueLanguageNotEnabled extends StatefulWidget {
  const CatalogueLanguageNotEnabled({super.key});

  @override
  State<CatalogueLanguageNotEnabled> createState() =>
      _CatalogueLanguageNotEnabledState();
}

class _CatalogueLanguageNotEnabledState
    extends State<CatalogueLanguageNotEnabled> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          CustomTitleSection(
            margin: 110,
            title: AppLocalizations.of(context)!.menu_languages_title,
            toolTip: AppLocalizations.of(context)!.menu_languages_tooltip,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: Colors.white,
              width: context.screenWidth * (context.isWide ? 0.4 : .8),
              height: 200,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: const Color.fromARGB(120, 155, 39, 176),
                    ),
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(color: Colors.transparent),
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
                              .menu_go_premium_to_unlock,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ]);
  }
}
