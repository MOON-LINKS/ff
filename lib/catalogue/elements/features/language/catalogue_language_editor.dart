import 'package:flutter/material.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';

class CatalogueLanguageEditor extends StatefulWidget {
  final String langKey;
  final VoidCallback closeWidget;
  final Function(String?, String, String) save;
  const CatalogueLanguageEditor(
      {super.key,
      required this.closeWidget,
      required this.langKey,
      required this.save});

  @override
  State<CatalogueLanguageEditor> createState() =>
      _CatalogueLanguageEditorState();
}

class _CatalogueLanguageEditorState extends State<CatalogueLanguageEditor> {
  Map<String, String>? lang;
  final languageOptions = [
    {"code": "en", "name": "English"},
    {"code": "ar", "name": "Arabic"},
    {"code": "fr", "name": "French"},
    {"code": "es", "name": "Spanish"},
    {"code": "de", "name": "German"},
    {"code": "it", "name": "Italian"},
    {"code": "pt", "name": "Portuguese (Brazil)"},
    {"code": "pt-PT", "name": "Portuguese (Portugal)"},
    {"code": "ru", "name": "Russian"},
    {"code": "zh-CN", "name": "Chinese (Simplified)"},
    {"code": "zh-TW", "name": "Chinese (Traditional)"},
    {"code": "ja", "name": "Japanese"},
    {"code": "ko", "name": "Korean"},
    {"code": "hi", "name": "Hindi"},
    {"code": "bn", "name": "Bengali"},
    {"code": "ur", "name": "Urdu"},
    {"code": "tr", "name": "Turkish"},
    {"code": "fa", "name": "Persian"},
    {"code": "he", "name": "Hebrew"},
    {"code": "id", "name": "Indonesian"},
    {"code": "ms", "name": "Malay"},
    {"code": "th", "name": "Thai"},
    {"code": "vi", "name": "Vietnamese"},
    {"code": "tl", "name": "Filipino"},
    {"code": "sw", "name": "Swahili"},
    {"code": "am", "name": "Amharic"},
    {"code": "ha", "name": "Hausa"},
    {"code": "yo", "name": "Yoruba"},
    {"code": "zu", "name": "Zulu"},
    {"code": "pl", "name": "Polish"},
    {"code": "nl", "name": "Dutch"},
    {"code": "sv", "name": "Swedish"},
    {"code": "da", "name": "Danish"},
    {"code": "no", "name": "Norwegian"},
    {"code": "fi", "name": "Finnish"},
    {"code": "cs", "name": "Czech"},
    {"code": "hu", "name": "Hungarian"},
    {"code": "ro", "name": "Romanian"},
    {"code": "el", "name": "Greek"},
    {"code": "uk", "name": "Ukrainian"},
    {"code": "bg", "name": "Bulgarian"},
    {"code": "sr", "name": "Serbian"},
    {"code": "hr", "name": "Croatian"},
    {"code": "sk", "name": "Slovak"},
    {"code": "sl", "name": "Slovenian"},
    {"code": "et", "name": "Estonian"},
    {"code": "lv", "name": "Latvian"},
    {"code": "lt", "name": "Lithuanian"},
    {"code": "ca", "name": "Catalan"},
    {"code": "eu", "name": "Basque"}
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth * (context.isWide ? 0.4 : .8),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          Positioned(
              right: 2,
              top: 1,
              child: IconButton(
                  onPressed: widget.closeWidget,
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ))),
          Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(
                    width: context.screenWidth * 0.5,
                    child: DropdownButtonFormField<Map<String, String>>(
                        style: TextStyle(color: Colors.white),
                        value: lang,
                        hint: Text(
                          AppLocalizations.of(context)!.menu_select_language,
                          style: TextStyle(color: Colors.white),
                        ),
                        items: languageOptions.map((language) {
                          return DropdownMenuItem<Map<String, String>>(
                            value: language,
                            child: Text(
                              language['name']!,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        selectedItemBuilder: (context) {
                          return languageOptions.map((language) {
                            return Text(
                              language['name']!,
                              style: TextStyle(color: Colors.white),
                            );
                          }).toList();
                        },
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.purple, width: 2),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple),
                          ),
                        ),
                        onChanged: (value) => setState(() {
                              lang = value;
                            }),
                        icon: Icon(Icons.arrow_drop_down_circle_outlined,
                            color: Colors.purple),
                        focusColor: Colors.purple)),
                const SizedBox(height: 10),
                CustomMenuButton(
                    onPressed: () {
                      if (lang != null) {
                        widget.save(
                            widget.langKey, lang!['code']!, lang!['name']!);
                        widget.closeWidget();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(AppLocalizations.of(context)!
                                .menu_language_required)));
                      }
                    },
                    child: AppLocalizations.of(context)!.menu_add_language)
              ]))),
        ],
      ),
    );
  }
}
