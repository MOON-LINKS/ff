import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/catalogue/elements/subcategories/catalogue_subcategory.dart';
import 'package:moonlinks/catalogue/elements/subcategories/catalogue_subcategory_editor.dart';
import 'package:moonlinks/catalogue/pages/catalogue_items.dart';
import 'package:moonlinks/catalogue/utils/catalogue_provider.dart';
import 'package:moonlinks/elements/appbar.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';

class CatalogueSubcategories extends ConsumerStatefulWidget {
  final String catUuid;
  const CatalogueSubcategories({super.key, required this.catUuid});

  @override
  ConsumerState<CatalogueSubcategories> createState() =>
      _CatalogueSubcategoriesState();
}

class _CatalogueSubcategoriesState
    extends ConsumerState<CatalogueSubcategories> {
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
                      .read(catalogueProvider.notifier)
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
              CatalogueItems(catUuid: widget.catUuid, subcatUuid: subUuid),
        ));
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(catalogueProvider);
    final subcategories =
        ref.read(catalogueProvider.notifier).searchCategoryNode(widget.catUuid);
    final title = subcategories["title"];
    final subs = subcategories['subcategories'];
    final sortedSubCategories = [...(subs ?? [])]..sort(
        (a, b) => (a['display_order'] ?? 0).compareTo(b['display_order'] ?? 0));
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
                        ((subcategories['subcategories'] ?? []).isNotEmpty)
                            ? ClipRRect(
                                child: SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  child: ReorderableListView(
                                    proxyDecorator: (child, index, animation) {
                                      return Material(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        child: child,
                                      );
                                    },
                                    children: [
                                      for (int i = 0;
                                          i < sortedSubCategories.length;
                                          i++)
                                        ReorderableDragStartListener(
                                          key: ValueKey(
                                              sortedSubCategories[i]['uuid']),
                                          index: i,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: CatalogueSubcategory(
                                              key: ValueKey(
                                                  sortedSubCategories[i]
                                                      ['uuid']),
                                              title: sortedSubCategories[i]
                                                  ['title'],
                                              update: () => updateSub(
                                                  sortedSubCategories[i]),
                                              itemNumber: sortedSubCategories[i]
                                                      ['items']
                                                  .length,
                                              delete: () => deleteSub(
                                                  sortedSubCategories[i]
                                                      ['uuid']),
                                              navigateItems: () =>
                                                  navigateItems(
                                                      sortedSubCategories[i]
                                                          ['uuid']),
                                            ),
                                          ),
                                        ),
                                    ],
                                    onReorder: (oldIndex, newIndex) {
                                      setState(() {
                                        if (newIndex > oldIndex) newIndex--;
                                        final item = sortedSubCategories
                                            .removeAt(oldIndex);
                                        sortedSubCategories.insert(
                                            newIndex, item);
                                        for (int i = 0;
                                            i < sortedSubCategories.length;
                                            i++) {
                                          sortedSubCategories[i]
                                              ['display_order'] = i;
                                        }
                                      });
                                      ref
                                          .read(catalogueProvider.notifier)
                                          .reorderSubCategories(widget.catUuid,
                                              oldIndex, newIndex);
                                    },
                                  ),
                                ),
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
            CatalogueSubcategoryEditor(
              key: ValueKey(subcategorySelected != null
                  ? subcategorySelected!['uuid']
                  : 'new'),
              isEditOpen: isEditorOpen,
              closeEditor: closeEditor,
              subcategory: subcategorySelected,
              categoryUuid: widget.catUuid,
              nextOrder: sortedSubCategories.length,
            )
          ],
        ));
  }
}
