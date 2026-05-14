import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/features/language/language_editor.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_checkbox.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_tooltip.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';
import 'package:moonlinks/menu/utils/menu_provider.dart';

class LanguageEnabled extends ConsumerStatefulWidget {
  const LanguageEnabled({super.key});

  @override
  ConsumerState<LanguageEnabled> createState() => _LanguageEnabledState();
}

class _LanguageEnabledState extends ConsumerState<LanguageEnabled> {
  bool editorOpen = false;
  String langKeySelected = '';
  @override
  Widget build(BuildContext context) {
    final payload = ref.watch(menuProvider)['payload'];
    final languages = (payload['languages'] is Map)
        ? Map<String, dynamic>.from(payload['languages'])
        : <String, dynamic>{};
    //final chosenLang = ref.watch(menuProvider)['language_chosen'];
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
          const SizedBox(height: 10),
          Text(
            '${AppLocalizations.of(context)!.menu_used}: ${languages.length}/6',
            style: TextStyle(
                color: languages.length == 6
                    ? Colors.yellowAccent
                    : Colors.greenAccent),
          ),
          const SizedBox(height: 10),
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                  color: Colors.white,
                  width: context.screenWidth * (context.isWide ? 0.4 : .8),
                  height: 350,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: SingleChildScrollView(
                      child: Column(
                    spacing: 20,
                    children: languages.entries.map((entry) {
                      final langKey = entry.key;
                      final langVal = entry.value;
                      return Container(
                          width:
                              context.screenWidth * (context.isWide ? 0.3 : .6),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(30)),
                          child: Stack(children: [
                            Center(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 10,
                              children: [
                                Text('${langVal['name']}',
                                    style: TextStyle(color: Colors.black)),
                                langKey != 'lang0'
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                            CustomMenuCheckbox(
                                                value: langVal['active'],
                                                onChanged: (val) {
                                                  final updatedLanguages =
                                                      Map<String, dynamic>.from(
                                                          languages);
                                                  updatedLanguages[langKey]
                                                      ['active'] = val;
                                                  ref
                                                      .read(
                                                          menuProvider.notifier)
                                                      .addOrUpdateInfo(
                                                          'languages',
                                                          updatedLanguages);
                                                }),
                                            Text(
                                                langVal['active']
                                                    ? AppLocalizations.of(
                                                            context)!
                                                        .menu_active
                                                    : AppLocalizations.of(
                                                            context)!
                                                        .menu_inactive,
                                                style: TextStyle(
                                                    color: langVal['active']
                                                        ? Colors.greenAccent
                                                        : Colors.redAccent))
                                          ])
                                    : const SizedBox.shrink(),
                                /* Row(
                                  spacing: 10,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomMenuButton(
                                        child: 'Edit',
                                        onPressed: () {
                                          setState(() {
                                            langKeySelected = langKey;
                                            editorOpen = true;
                                          });
                                        }),
                                     chosenLang == langKey
                                        ? Text(
                                            'Language Chosen',
                                            style: TextStyle(
                                              color: Colors.purple,
                                            ),
                                          )
                                        : CustomMenuButton(
                                            child: 'Choose',
                                            onPressed: () {
                                              ref
                                                  .read(menuProvider.notifier)
                                                  .updateChosenLang(langKey);
                                            }) 
                                  ],
                                ),*/
                              ],
                            )),
                            Positioned(
                              right: 5,
                              top: 2,
                              child: langKey != 'lang0'
                                  ? IconButton(
                                      onPressed: () {
                                        final newLanguages =
                                            Map<String, dynamic>.from(
                                                languages);
                                        newLanguages.remove(langKey);
                                        ref
                                            .read(menuProvider.notifier)
                                            .addOrUpdateInfo(
                                                'languages', newLanguages);
                                      },
                                      icon: Icon(
                                        Icons.delete_outlined,
                                        color: Colors.purple,
                                      ))
                                  : CustomMenuTooltip(
                                      message: AppLocalizations.of(context)!
                                          .menu_main_language_locked),
                            )
                          ]));
                    }).toList(),
                  )))),
          const SizedBox(height: 10),
          languages.length < 6
              ? !editorOpen
                  ? CustomMenuButton(
                      child: AppLocalizations.of(context)!.menu_add_language,
                      onPressed: () {
                        setState(() {
                          langKeySelected = 'lang${languages.length}';
                          editorOpen = !editorOpen;
                        });
                      })
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
          editorOpen
              ? LanguageEditor(
                  closeWidget: () {
                    setState(() {
                      langKeySelected = '';
                      editorOpen = false;
                    });
                  },
                  save: (langKeySelected, langCode, langName) {
                    final newLanguages = Map<String, dynamic>.from(languages);
                    newLanguages[langKeySelected!] = {
                      'name': langName,
                      'code': langCode,
                      'active': true
                    };
                    ref
                        .read(menuProvider.notifier)
                        .addOrUpdateInfo('languages', newLanguages);
                  },
                  langKey: langKeySelected,
                )
              : const SizedBox.shrink()
        ]);
  }
}
