import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';

class CustomCataloguePublishbar extends StatelessWidget {
  final String link;
  final VoidCallback onPublish;
  const CustomCataloguePublishbar({
    super.key,
    required this.onPublish,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.menu_tap_link_copy,
                style: TextStyle(color: Colors.black, fontSize: 12)),
            InkWell(
              onTap: () async {
                await Clipboard.setData(
                  ClipboardData(text: link),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(AppLocalizations.of(context)!.menu_link_copied),
                  ),
                );
              },
              child: Text(
                link,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CustomMenuButton(
              child: AppLocalizations.of(context)!.menu_publish,
              onPressed: onPublish,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ],
        ),
      ),
    );
  }
}
