import 'package:flutter/material.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_input.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_ordering_system.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';

class BranchEditor extends StatefulWidget {
  final bool isOpen;
  final int countryId;
  final Function(int, String, String, dynamic) save;
  final VoidCallback closeWidget;
  const BranchEditor(
      {super.key,
      required this.countryId,
      required this.closeWidget,
      required this.isOpen,
      required this.save});

  @override
  State<BranchEditor> createState() => _BranchEditorState();
}

class _BranchEditorState extends State<BranchEditor> {
  final formKey = GlobalKey<FormState>();
  final branchName = TextEditingController();
  final branchLink = TextEditingController();
  dynamic phoneInfo = {};
  @override
  void dispose() {
    branchName.dispose();
    branchLink.dispose();
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
                              child: AppLocalizations.of(context)!
                                  .menu_new_branch),
                          const SizedBox(height: 10),
                          CustomMenuInput(
                            controller: branchName,
                            hintText: AppLocalizations.of(context)!
                                .menu_branch_name_hint,
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
                          CustomMenuInput(
                            controller: branchLink,
                            hintText: AppLocalizations.of(context)!
                                .menu_branch_link_hint,
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
                          CustomTitleSection(
                            margin: 135,
                            title: AppLocalizations.of(context)!.menu_ordering,
                            toolTip: AppLocalizations.of(context)!
                                .branch_ordering_hint,
                          ),
                          const SizedBox(height: 5),
                          CustomOrderingSystem(
                            countryCode: null,
                            countryISO: null,
                            phoneNumber: null,
                            onNumChange: (phoneData) {
                              setState(() {
                                phoneInfo = {
                                  'countryCode': phoneData.countryCode,
                                  'countryISOCode': phoneData.countryISO,
                                  'number': phoneData.number,
                                  'platforms': []
                                };
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomMenuButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  widget.save(widget.countryId, branchName.text,
                                      branchLink.text, phoneInfo);
                                  branchName.clear();
                                  branchLink.clear();
                                }
                              },
                              child:
                                  AppLocalizations.of(context)!.menu_add_branch)
                        ],
                      ))),
            )
          ],
        ));
  }
}
