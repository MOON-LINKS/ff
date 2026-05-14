import 'package:flutter/material.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_divider.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_input.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';

class MenuNoDomain extends StatefulWidget {
  final Future<void> Function(String domain) addDomain;
  const MenuNoDomain({super.key, required this.addDomain});

  @override
  State<MenuNoDomain> createState() => _MenuNoDomainState();
}

class _MenuNoDomainState extends State<MenuNoDomain> {
  TextEditingController domainController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 15,
      children: [
        CustomTitleSection(
          margin: 120,
          title: AppLocalizations.of(context)!.menu_add_your_domain,
          toolTip:
              '${AppLocalizations.of(context)!.menu_domain_input_label} \n ${AppLocalizations.of(context)!.menu_domain_input_example}',
        ),
        const CustomDivider(),
        Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          width: context.screenWidth * (context.isWide ? .4 : .8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          child: Center(
              child: Column(
            spacing: 10,
            children: [
              CustomMenuInput(
                controller: domainController,
                hintText: AppLocalizations.of(context)!.menu_domain_input_hint,
                function: (_) {},
              ),
              CustomMenuButton(
                  child: AppLocalizations.of(context)!.menu_add_domain,
                  onPressed: () async {
                    final domain = domainController.text.trim();
                    try {
                      await widget.addDomain(domain);
                    } catch (e) {
                      print(e);
                    }
                  })
            ],
          )),
        )
      ],
    ));
  }
}
