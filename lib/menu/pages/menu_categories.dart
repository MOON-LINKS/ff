import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/elements/appbar.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/category/custom_category.dart';
import 'package:moonlinks/menu/elements/category/custom_category_editor.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_color_picker.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_tooltip.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_title_section.dart';
import 'package:moonlinks/menu/utils/menu_provider.dart';

class MenuCategories extends ConsumerStatefulWidget {
  const MenuCategories({super.key});
  @override
  ConsumerState<MenuCategories> createState() => _MenuCategories();
}

class _MenuCategories extends ConsumerState<MenuCategories> {
  @override
  void initState() {
    super.initState();
  }

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
                        .read(menuProvider.notifier)
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
    final menuState = ref.watch(menuProvider);
    final categories = menuState['payload']['categories'];
    final menuNotifier = ref.read(menuProvider.notifier);
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
                                    color: menuState['payload']['design']
                                        ['category-primary'],
                                    newColor: (newColor) {
                                      final design = cloneMap(
                                          menuState['payload']['design']);
                                      design['category-primary'] = newColor;

                                      menuNotifier.addOrUpdateInfo(
                                          'design', design);
                                    }),
                                CustomColorPicker(
                                    text: AppLocalizations.of(context)!
                                        .menu_secondary,
                                    color: menuState['payload']['design']
                                        ['category-secondary'],
                                    newColor: (newColor) {
                                      final design = cloneMap(
                                          menuState['payload']['design']);
                                      design['category-secondary'] = newColor;

                                      menuNotifier.addOrUpdateInfo(
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
                      (categories != null && categories.isNotEmpty)
                          ? Wrap(
                              spacing: 30,
                              runSpacing: 20,
                              children: categories.map<Widget>((category) {
                                return IntrinsicWidth(
                                    child: CustomCategory(
                                  key: ValueKey(category['uuid']),
                                  hasInventoryFeature: menuState['features']
                                          ['category_image_enabled'] ??
                                      0,
                                  title: category['title'],
                                  icon: category['icon_key'],
                                  imageUrl: category['image_url'],
                                  subcatNumber:
                                      category['subcategories'].length,
                                  updateCategory: () =>
                                      updateCategoryClicked(category),
                                  deleteCategory: () =>
                                      deleteCategoryClicked(category['uuid']),
                                ));
                              }).toList(),
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
                      /* Text(
                        menuState['meta']['isPublished'] == false
                            ? 'Not Published Yet'.toUpperCase()
                            : 'You Applied Changes'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ), */
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
          CustomCategoryEditor(
            key: ValueKey(
                categorySelected != null ? categorySelected!['uuid'] : 'new'),
            isEditOpen: isEditorOpen,
            hasInventoryFeature:
                menuState['features']['category_image_enabled'] ?? 0,
            closeEditor: () {
              closeEditor();
              deleteCategorySelected();
            },
            category: categorySelected,
          ),
        ]));
  }
}
