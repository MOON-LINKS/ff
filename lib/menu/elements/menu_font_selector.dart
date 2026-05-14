import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';
import 'package:moonlinks/menu/utils/menu_provider.dart';

class MenuFontSelector extends ConsumerStatefulWidget {
  final Function(String) function;
  const MenuFontSelector({super.key, required this.function});

  @override
  ConsumerState<MenuFontSelector> createState() => _MenuFontSelectorState();
}

class _MenuFontSelectorState extends ConsumerState<MenuFontSelector> {
  final List<String> _fonts = [
    'Times',
    'Merriweather',
    'Franklin',
    'Montserrat',
    'Oswald',
    'Raleway',
    'NotoSans',
    'NotoSansArabic',
    'NotoKufiArabic',
    'NotoSansHebrew',
    'NotoSansJapanese',
    'NotoSansKorean',
    'NotoSansMono',
    'NotoSansSyriac',
    'NotoSansAdlam',
    'NotoSansGeorgian',
    'NotoSansSC',
    'NotoSansTC',
    'NotoSansThai',
    'NotoSerifArmenian',
    'NotoSerifBengali',
    'NotoSerifDevanagari',
    'NotoSerifEthiopic',
    'NotoUrdu',
  ];
  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    String selectedFont = menuState['payload']['font'] ?? '';
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          CustomTitleSection(
            margin: 80,
            title: AppLocalizations.of(context)!.menu_fonts_title,
            toolTip: AppLocalizations.of(context)!.menu_fonts_tooltip,
          ),
          Container(
              height: 400,
              width: context.screenWidth * (context.isWide ? 0.4 : .8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: _fonts.map((font) {
                    return RadioListTile<String>(
                        activeColor: Colors.purple,
                        title: Row(spacing: 5, children: [
                          Text(font.toString().toUpperCase(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14)),
                          GestureDetector(
                            onTap: () {
                              // Show preview image dialog
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: SvgPicture.network(
                                    'https://cdn.moonlinks.me/fonts/$font.svg',
                                    width: 200,
                                    height: 60,
                                    placeholderBuilder: (_) =>
                                        CircularProgressIndicator(
                                      color: Colors.purple,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.info_outline,
                              color: Colors.purple,
                            ),
                          ),
                        ]),
                        value: font,
                        groupValue: selectedFont,
                        onChanged: (value) async {
                          await widget.function(value!);
                          setState(() {
                            selectedFont = value;
                          });
                        });
                  }).toList(),
                ),
              ))
        ]);
  }
}
