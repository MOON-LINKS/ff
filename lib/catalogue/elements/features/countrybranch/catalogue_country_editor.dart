import 'package:flutter/material.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_input.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';

class CatalogueCountryEditor extends StatefulWidget {
  final bool isOpen;
  final VoidCallback closeWidget;
  final Function(String) save;
  const CatalogueCountryEditor(
      {super.key,
      required this.isOpen,
      required this.closeWidget,
      required this.save});

  @override
  State<CatalogueCountryEditor> createState() => _CatalogueCountryEditorState();
}

class _CatalogueCountryEditorState extends State<CatalogueCountryEditor> {
  final formKey = GlobalKey<FormState>();
  final countryInput = TextEditingController();
  @override
  void dispose() {
    countryInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isOpen == false) return const SizedBox.shrink();

    return Container(
      width: context.screenWidth * (context.isWide ? .3 : .8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: widget.closeWidget,
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                )),
          ),
          Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 15),
              child: Center(
                  child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomMenuTitle(
                              child:
                                  AppLocalizations.of(context)!.menu_country),
                          const SizedBox(height: 10),
                          CustomMenuInput(
                            controller: countryInput,
                            hintText:
                                AppLocalizations.of(context)!.menu_country_name,
                            function: (_) {},
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .menu_field_required;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomMenuButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  widget.save(countryInput.text);
                                  countryInput.clear();
                                }
                              },
                              child: AppLocalizations.of(context)!
                                  .menu_add_country)
                        ],
                      ))))
        ],
      ),
    );
  }
}
