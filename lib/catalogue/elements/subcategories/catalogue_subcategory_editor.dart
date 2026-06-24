import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/catalogue/utils/catalogue_provider.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_input.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';
import 'package:uuid/uuid.dart';

class CatalogueSubcategoryEditor extends ConsumerStatefulWidget {
  final bool isEditOpen;
  final VoidCallback closeEditor;
  final LinkedHashMap<dynamic, dynamic>? subcategory;
  final String categoryUuid;
  final int nextOrder;
  const CatalogueSubcategoryEditor(
      {super.key,
      required this.isEditOpen,
      required this.closeEditor,
      this.subcategory,
      required this.categoryUuid,
      required this.nextOrder});

  @override
  ConsumerState<CatalogueSubcategoryEditor> createState() =>
      _CatalogueSubcategoryEditorState();
}

class _CatalogueSubcategoryEditorState
    extends ConsumerState<CatalogueSubcategoryEditor> {
  late TextEditingController titleController;
  late int displayOrder;
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(
        text: widget.subcategory != null
            ? widget.subcategory!['title'] ?? ''
            : '');
    displayOrder = widget.subcategory != null
        ? (widget.subcategory!['display_order'] ?? 0)
        : widget.nextOrder;
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEditOpen) return const SizedBox.shrink();
    final isNew = widget.subcategory == null;
    return Stack(
      children: [
        Positioned.fill(
            child: GestureDetector(
          onTap: widget.closeEditor,
          child: Container(
            color: const Color.fromARGB(50, 197, 197, 197),
          ),
        )),
        Center(
          child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black, blurRadius: 20, spreadRadius: 2)
                  ]),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: widget.closeEditor,
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        )),
                  ),
                  CustomMenuTitle(
                      child: isNew
                          ? AppLocalizations.of(context)!
                              .menu_add_subcategory_title
                          : AppLocalizations.of(context)!
                              .menu_edit_subcategory_title),
                  const SizedBox(height: 20),
                  CustomMenuInput(
                    controller: titleController,
                    function: (_) {},
                    hintText:
                        AppLocalizations.of(context)!.menu_subcategory_name,
                  ),
                  const SizedBox(height: 20),
                  CustomMenuButton(
                    onPressed: () {
                      final title = titleController.text.trim();
                      //add here || title existed
                      if (title.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(AppLocalizations.of(context)!
                              .menu_subcategory_name_required),
                          backgroundColor: Colors.redAccent,
                          duration: Duration(seconds: 2),
                        ));
                        return;
                      }
                      final uuid = widget.subcategory?['uuid'] ??
                          'sub-${const Uuid().v4()}';
                      ref
                          .read(catalogueProvider.notifier)
                          .addOrModifySubcategory(
                              uuid, widget.categoryUuid, title, displayOrder);
                      titleController.clear();
                      widget.closeEditor();
                    },
                    child: isNew
                        ? AppLocalizations.of(context)!.menu_add_close
                        : AppLocalizations.of(context)!.menu_save_close,
                  )
                ],
              )),
        )
      ],
    );
  }
}
