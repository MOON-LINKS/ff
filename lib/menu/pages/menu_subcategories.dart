import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/elements/appbar.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/sub/custom_subcategory.dart';
import 'package:moonlinks/menu/elements/sub/custom_subcategory_editor.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';
import 'package:moonlinks/menu/pages/menu_items.dart';
import 'package:moonlinks/menu/utils/menu_provider.dart';

class MenuSubcategories extends ConsumerStatefulWidget {
  final String catUuid;
  const MenuSubcategories({super.key, required this.catUuid});
  @override
  ConsumerState<MenuSubcategories> createState() => _MenuSubcategories();
}

class _MenuSubcategories extends ConsumerState<MenuSubcategories> {
/*   @override
  initState() {
    super.initState();
    final loadedSub =
        ref.read(menuProvider.notifier).searchCategoryNode(widget.catUuid);
    setState(() {
      subcategories = loadedSub;
    });
  } */

  bool isEditorOpen = false;
  LinkedHashMap<dynamic, dynamic>? subcategorySelected;
  void addNewClicked() {
    setState(() {
      subcategorySelected = null;
      isEditorOpen = true;
    });
  }

  void closeEditor() {
    setState(() {
      subcategorySelected = null;
      isEditorOpen = false;
    });
  }

  void updateSub(LinkedHashMap<dynamic, dynamic>? sub) {
    setState(() {
      subcategorySelected = sub;
      isEditorOpen = true;
    });
  }

  void deleteSub(String subUuid) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.purple,
              width: 2,
            ),
          ),
          title: Align(
              alignment: Alignment.centerLeft,
              child: CustomMenuTitle(
                  child:
                      AppLocalizations.of(context)!.menu_delete_subcategory)),
          content: Text(
              AppLocalizations.of(context)!.menu_delete_subcategory_message),
          actions: [
            CustomMenuButton(
                onPressed: () => Navigator.pop(context),
                child: AppLocalizations.of(context)!.cancel),
            CustomMenuButton(
                onPressed: () {
                  ref
                      .read(menuProvider.notifier)
                      .deleteSubcategory(subUuid, widget.catUuid);
                  Navigator.of(context).pop();
                },
                child: AppLocalizations.of(context)!.menu_delete),
          ],
        );
      },
    );
  }

  void navigateItems(String subUuid) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MenuItems(catUuid: widget.catUuid, subcatUuid: subUuid),
        ));
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(menuProvider);
    final subcategories =
        ref.read(menuProvider.notifier).searchCategoryNode(widget.catUuid);
    final title = subcategories["title"];
    return Scaffold(
        appBar: CustomAppBar(haveIcon: true),
        body: Stack(
          children: [
            Column(children: [
              Expanded(
                  child: SingleChildScrollView(
                      padding: EdgeInsets.all(20),
                      child: Column(children: [
                        const SizedBox(height: 30),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomMenuTitle(
                                  child:
                                      '${AppLocalizations.of(context)!.menu_subcategories_for} $title')
                            ]),
                        const SizedBox(height: 20),
                        (subcategories['subcategories'].isNotEmpty)
                            ? Column(
                                children: subcategories['subcategories']
                                    .map<Widget>((sub) {
                                  return CustomSubcategory(
                                      key: ValueKey(sub['uuid']),
                                      title: sub['title'],
                                      update: () => updateSub(sub),
                                      itemNumber: sub['items'].length,
                                      delete: () => deleteSub(sub['uuid']),
                                      navigateItems: () =>
                                          navigateItems(sub['uuid']));
                                }).toList(),
                              )
                            : Text(AppLocalizations.of(context)!
                                .menu_no_subcategories_found),
                      ]))),
              SafeArea(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white),
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      children: [
                        CustomMenuButton(
                            child: AppLocalizations.of(context)!
                                .menu_add_subcategory,
                            onPressed: addNewClicked,
                            fontSize: 32,
                            fontWeight: FontWeight.w800)
                      ],
                    ),
                  ),
                ),
              )
            ]),
            CustomSubcategoryEditor(
                key: ValueKey(subcategorySelected != null
                    ? subcategorySelected!['uuid']
                    : 'new'),
                isEditOpen: isEditorOpen,
                closeEditor: closeEditor,
                subcategory: subcategorySelected,
                categoryUuid: widget.catUuid)
          ],
        ));
  }
}
