import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';

class CustomMenuPublishbar extends StatelessWidget {
  final bool show;
  final String link;
  final VoidCallback onPublish;

  const CustomMenuPublishbar({
    super.key,
    required this.show,
    required this.onPublish,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: show ? Offset.zero : const Offset(0, 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: show ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: SafeArea(
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
                        content: Text(
                            AppLocalizations.of(context)!.menu_link_copied),
                      ),
                    );
                  },
                  child: Text(
                    link,
                    style: const TextStyle(
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
        ),
      ),
    );
  }
}
