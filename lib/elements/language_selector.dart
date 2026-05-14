import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:moonlinks/elements/button.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/utils/locale_provider.dart';

class LanguageSelector extends ConsumerStatefulWidget {
  const LanguageSelector({super.key});

  @override
  ConsumerState<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends ConsumerState<LanguageSelector> {
  final List<Map<String, String>> languages = [
    {'lang': 'English', 'code': 'en'},
    {'lang': 'العربية', 'code': 'ar'},
    {'lang': 'Français', 'code': 'fr'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Column(children: [
          Text(
            AppLocalizations.of(context)!.language_title,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
          ),
          CustomButton(
              function: () {
                showDialog(
                  context: context,
                  builder: (_) => Center(
                    child: Consumer(
                      builder: (context, ref, _) {
                        final selectedLang = ref.watch(localeProvider);

                        return Container(
                            width: context.screenWidth *
                                (context.isWide ? .5 : .7),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(166, 0, 0, 0),
                                border:
                                    Border.all(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              spacing: 20,
                              mainAxisSize: MainAxisSize.min,
                              children: languages.map((el) {
                                final isSelected =
                                    selectedLang.languageCode == el['code'];

                                return isSelected
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            el['lang']!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 25,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .selected,
                                            style: TextStyle(
                                              color: Colors.greenAccent,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      )
                                    : CustomButton(
                                        function: () async {
                                          await ref
                                              .read(localeProvider.notifier)
                                              .setLocale(el['code']!);
                                        },
                                        name: el['lang']!,
                                      );
                              }).toList(),
                            ));
                      },
                    ),
                  ),
                );
              },
              name: "Choose Language"),
        ]));
  }
}
