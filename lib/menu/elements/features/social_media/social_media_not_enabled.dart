import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_checkbox.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';

class SocialMediaNotEnabled extends StatefulWidget {
  const SocialMediaNotEnabled({super.key});

  @override
  State<SocialMediaNotEnabled> createState() => _SocialMediaNotEnabledState();
}

class _SocialMediaNotEnabledState extends State<SocialMediaNotEnabled> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTitleSection(
          margin: 120,
          title: AppLocalizations.of(context)!.menu_social_media_title,
          toolTip: AppLocalizations.of(context)!.menu_social_media_tooltip,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CustomMenuCheckbox(value: false, onChanged: (_) {})],
        ),
        const SizedBox(height: 10),
        ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(30),
            child: Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(color: Colors.white),
                  width: MediaQuery.of(context).size.width * .8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 30,
                    children: [
                      CustomMenuButton(
                          child: AppLocalizations.of(context)!.menu_add_link,
                          onPressed: () {}),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 10,
                        children: [
                          Icon(Icons.south_america_outlined,
                              color: Colors.purple),
                          Expanded(child: CustomMenuTitle(child: 'URL1')),
                          Icon(
                            Icons.delete_outline,
                            color: Colors.purple,
                          )
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Icon(Icons.south_america_outlined,
                              color: Colors.purple),
                          Expanded(child: CustomMenuTitle(child: 'URL1')),
                          Icon(
                            Icons.delete_outline,
                            color: Colors.purple,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                    child: Stack(children: [
                  Container(color: const Color.fromARGB(120, 155, 39, 176)),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(color: Colors.transparent),
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
                        AppLocalizations.of(context)!.menu_go_pro_to_unlock,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ))
                ]))
              ],
            ))
      ],
    );
  }
}
