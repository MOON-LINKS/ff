import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/catalogue/elements/categories/catalogue_category.dart';
import 'package:moonlinks/catalogue/elements/categories/catalogue_category_editor.dart';
import 'package:moonlinks/catalogue/utils/catalogue_provider.dart';
import 'package:moonlinks/elements/appbar.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_color_picker.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_tooltip.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';

class CatalogueCategories extends ConsumerStatefulWidget {
  const CatalogueCategories({super.key});

  @override
  ConsumerState<CatalogueCategories> createState() =>
      _CatalogueCategoriesState();
}

class _CatalogueCategoriesState extends ConsumerState<CatalogueCategories> {
  bool isEditorOpen = false;
  bool isColorPickerOpen = false;
  LinkedHashMap<dynamic, dynamic>? categorySelected;

  void deleteCategorySelected() {
    setState(() => categorySelected = null);
  }

  void openEditor() => setState(() => isEditorOpen = true);
  void closeEditor() => setState(() => isEditorOpen = false);
  void addNewClicked() {
    setState(() {
      categorySelected = null;
      isEditorOpen = true;
    });
  }

  void updateCategoryClicked(LinkedHashMap<dynamic, dynamic>? category) {
    setState(() {
      categorySelected = category;
      isEditorOpen = true;
    });
  }

  void deleteCategoryClicked(String categoryUuid) {
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
                    child: AppLocalizations.of(context)!.menu_delete_category)),
            content: Text(
                AppLocalizations.of(context)!.menu_delete_category_message),
            actions: [
              CustomMenuButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: AppLocalizations.of(context)!.cancel),
              CustomMenuButton(
                  onPressed: () {
                    ref
                        .read(catalogueProvider.notifier)
                        .deleteCategory(categoryUuid);
                    Navigator.of(context).pop();
                  },
                  child: AppLocalizations.of(context)!.menu_delete),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final catalogueState = ref.watch(catalogueProvider);
    final categories = catalogueState['payload']['categories'];
    final catalogueNotifier = ref.read(catalogueProvider.notifier);
    final sortedCategories = [...(categories ?? [])]..sort(
        (a, b) => (a['display_order'] ?? 0).compareTo(b['display_order'] ?? 0));
    Map<String, dynamic> cloneMap(Map<String, dynamic> map) {
      return jsonDecode(jsonEncode(map)) as Map<String, dynamic>;
    }

    return Scaffold(
        appBar: CustomAppBar(haveIcon: true),
        body: Stack(children: [
          Column(children: [
            Expanded(
                child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(children: [
                      const SizedBox(height: 30),
                      CustomTitleSection(
                        margin: 100,
                        title:
                            AppLocalizations.of(context)!.menu_categories_title,
                        toolTip: AppLocalizations.of(context)!
                            .menu_categories_tooltip,
                      ),
                      const SizedBox(height: 30),
                      Wrap(
                          spacing: 10,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            CustomMenuTitle(
                                child: AppLocalizations.of(context)!
                                    .menu_category_icon_colors),
                            CustomMenuTooltip(
                                message: AppLocalizations.of(context)!
                                    .menu_category_icon_colors_hint),
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple),
                                onPressed: () {
                                  setState(() {
                                    isColorPickerOpen = !isColorPickerOpen;
                                  });
                                },
                                label: Text(
                                    isColorPickerOpen
                                        ? AppLocalizations.of(context)!
                                            .menu_close_picker
                                        : AppLocalizations.of(context)!
                                            .menu_open_picker,
                                    style: TextStyle(color: Colors.white)),
                                icon: Icon(
                                  isColorPickerOpen
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: Colors.white,
                                ))
                          ]),
                      const SizedBox(height: 20),
                      isColorPickerOpen
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 10,
                              children: [
                                CustomColorPicker(
                                    text: AppLocalizations.of(context)!
                                        .menu_primary,
                                    color: catalogueState['payload']['design']
                                        ['category-primary'],
                                    newColor: (newColor) {
                                      final design = cloneMap(
                                          catalogueState['payload']['design']);
                                      design['category-primary'] = newColor;

                                      catalogueNotifier.addOrUpdateInfo(
                                          'design', design);
                                    }),
                                CustomColorPicker(
                                    text: AppLocalizations.of(context)!
                                        .menu_secondary,
                                    color: catalogueState['payload']['design']
                                        ['category-secondary'],
                                    newColor: (newColor) {
                                      final design = cloneMap(
                                          catalogueState['payload']['design']);
                                      design['category-secondary'] = newColor;

                                      catalogueNotifier.addOrUpdateInfo(
                                          'design', design);
                                    }),
                              ],
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 30),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomMenuTitle(
                                child: AppLocalizations.of(context)!
                                    .menu_category_list),
                          ]),
                      const SizedBox(height: 20),
                      (sortedCategories.isNotEmpty)
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
                                        i < sortedCategories.length;
                                        i++)
                                      ReorderableDragStartListener(
                                        key: ValueKey(
                                            sortedCategories[i]['uuid']),
                                        index: i,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: CatalogueCategory(
                                            key: ValueKey(
                                                sortedCategories[i]['uuid']),
                                            hasInventoryFeature: catalogueState[
                                                        'features'][
                                                    'category_image_enabled'] ??
                                                0,
                                            title: sortedCategories[i]['title'],
                                            icon: sortedCategories[i]
                                                ['icon_key'],
                                            imageUrl: sortedCategories[i]
                                                ['image_url'],
                                            subcatNumber: sortedCategories[i]
                                                        ['subcategories']
                                                    ?.length ??
                                                0,
                                            updateCategory: () =>
                                                updateCategoryClicked(
                                                    sortedCategories[i]),
                                            deleteCategory: () =>
                                                deleteCategoryClicked(
                                                    sortedCategories[i]
                                                        ['uuid']),
                                          ),
                                        ),
                                      ),
                                  ],
                                  onReorder: (oldIndex, newIndex) {
                                    ref
                                        .read(catalogueProvider.notifier)
                                        .reorderCategories(oldIndex, newIndex);
                                  },
                                  /* onReorder: (oldIndex, newIndex) {
                                    setState(() {
                                      if (newIndex > oldIndex) newIndex--;
                                      final item =
                                          sortedCategories.removeAt(oldIndex);
                                      sortedCategories.insert(newIndex, item);
                                      for (int i = 0;
                                          i < sortedCategories.length;
                                          i++) {
                                        sortedCategories[i]['display_order'] =
                                            i;
                                      }
                                    });
                                    ref
                                        .read(catalogueProvider.notifier)
                                        .reorderCategories(oldIndex, newIndex);
                                  }, */
                                ),
                              ),
                            )
                          : Text(
                              AppLocalizations.of(context)!.menu_no_categories),
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
                          child:
                              AppLocalizations.of(context)!.menu_add_category,
                          onPressed: addNewClicked,
                          fontSize: 30,
                          fontWeight: FontWeight.w800)
                    ],
                  ),
                ),
              ),
            )
          ]),
          CatalogueCategoryEditor(
            key: ValueKey(
                categorySelected != null ? categorySelected!['uuid'] : 'new'),
            isEditOpen: isEditorOpen,
            hasInventoryFeature:
                catalogueState['features']['category_image_enabled'] ?? 0,
            closeEditor: () {
              closeEditor();
              deleteCategorySelected();
            },
            category: categorySelected,
          ),
        ]));
  }
}
