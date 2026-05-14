import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/elements/appbar.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/item/custom_item.dart';
import 'package:moonlinks/menu/elements/item/custom_item_editor.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_tooltip.dart';
import 'package:moonlinks/menu/utils/menu_provider.dart';

class MenuItems extends ConsumerStatefulWidget {
  final String catUuid;
  final String subcatUuid;
  const MenuItems({super.key, required this.catUuid, required this.subcatUuid});

  @override
  ConsumerState<MenuItems> createState() => _MenuItemsState();
}

class _MenuItemsState extends ConsumerState<MenuItems> {
  bool isEditorOpen = false;
  LinkedHashMap<dynamic, dynamic>? itemSelected;
  void addNewClicked() {
    setState(() {
      itemSelected = null;
      isEditorOpen = true;
    });
  }

  void closeEditor() {
    setState(() {
      itemSelected = null;
      isEditorOpen = false;
    });
  }

  void updateItem(LinkedHashMap<dynamic, dynamic>? item) {
    setState(() {
      itemSelected = item;
      isEditorOpen = true;
    });
  }

  void deleteItem(String itemUuid) {
    showDialog(
      context: context,
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
                  child: AppLocalizations.of(context)!.menu_delete_item)),
          content: Text(AppLocalizations.of(context)!.menu_delete_item_message),
          actions: [
            CustomMenuButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: AppLocalizations.of(context)!.cancel),
            CustomMenuButton(
                onPressed: () {
                  ref
                      .watch(menuProvider.notifier)
                      .deleteItem(itemUuid, widget.subcatUuid, widget.catUuid);
                  Navigator.pop(context);
                },
                child: AppLocalizations.of(context)!.menu_delete)
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    final menuNotifier = ref.read(menuProvider.notifier);
    final items = menuNotifier.searchSubcategoryNode(
      widget.catUuid,
      widget.subcatUuid,
    );
    if (items['items'] != null) {
      for (int i = 0; i < items['items'].length; i++) {
        items['items'][i]['display_order'] ??= i;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final imageCounter = menuState['image_counter'] ?? 0;
    final imageAllowed = menuState['features']['total_image'] ?? 0;
    final addedOnImages = (menuState['addons_images']['status'] == 'active' ||
            (menuState['addons_images']['status'] == 'cancelled' &&
                DateTime.parse(menuState['addons_images']['ends_at'])
                    .isAfter(DateTime.now())))
        ? menuState['addons_images']['quantity'] ?? 0
        : 0;
    final items = ref
        .read(menuProvider.notifier)
        .searchSubcategoryNode(widget.catUuid, widget.subcatUuid);
    final title = items['title'];
    return Scaffold(
        appBar: CustomAppBar(haveIcon: true),
        body: Stack(
          children: [
            Column(children: [
              Expanded(
                  child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      '${AppLocalizations.of(context)!.menu_images_used}: $imageCounter / ${imageAllowed + addedOnImages}',
                      style: TextStyle(
                          color: imageCounter < (imageAllowed + addedOnImages)
                              ? Colors.greenAccent
                              : Colors.redAccent),
                    ),
                    const SizedBox(height: 15),
                    Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomMenuTitle(
                              child:
                                  '${AppLocalizations.of(context)!.menu_items_for} $title'),
                          CustomMenuTooltip(
                              message: AppLocalizations.of(context)!
                                  .menu_items_manage_hint)
                        ]),
                    const SizedBox(height: 20),
                    (items['items'].isNotEmpty)
                        ? ClipRRect(
                            child: SizedBox(
                                width: context.screenWidth *
                                    (context.isWide ? .3 : .8),
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: ReorderableListView(
                                  children: [
                                    for (int i = 0;
                                        i < items['items'].length;
                                        i++)
                                      ReorderableDragStartListener(
                                        key:
                                            ValueKey(items['items'][i]['uuid']),
                                        index: i,
                                        child: CustomItem(
                                          title: items['items'][i]['title'],
                                          description: items['items'][i]
                                              ['description'],
                                          mainImageUrl: items['items'][i]
                                              ['main_image_url'],
                                          displayOrder: i,
                                          badges: items['items'][i]['badges'],
                                          isActive: items['items'][i]
                                              ['is_active'],
                                          types: items['items'][i]['types'],
                                          prices: items['items'][i]['prices'],
                                          updateItem: () =>
                                              updateItem(items['items'][i]),
                                          deleteItem: () {
                                            deleteItem(
                                                items['items'][i]['uuid']);
                                            if (items['items'] != null) {
                                              for (int i = 0;
                                                  i < items['items'].length;
                                                  i++) {
                                                items['items'][i]
                                                    ['display_order'] ??= i;
                                              }
                                            }
                                          },
                                          images:
                                              items['items'][i]['images'] ?? [],
                                        ),
                                      ),
                                  ],
                                  onReorder: (oldIndex, newIndex) {
                                    setState(() {
                                      if (newIndex > oldIndex) newIndex--;
                                      final item =
                                          items['items'].removeAt(oldIndex);
                                      items['items'].insert(newIndex, item);
                                      for (int i = 0;
                                          i < items['items'].length;
                                          i++) {
                                        items['items'][i]['display_order'] = i;
                                      }
                                    });
                                  },
                                )))
                        : Text(AppLocalizations.of(context)!.menu_no_items),
                  ],
                ),
              )),
              SafeArea(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white),
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      children: [
                        CustomMenuButton(
                            child: AppLocalizations.of(context)!.menu_add_item,
                            onPressed: addNewClicked,
                            fontSize: 32,
                            fontWeight: FontWeight.w800)
                      ],
                    ),
                  ),
                ),
              )
            ]),
            CustomItemEditor(
              key: ValueKey(
                  itemSelected != null ? itemSelected!['uuid'] : 'new'),
              isEditOpen: isEditorOpen,
              closeEditor: closeEditor,
              catUuid: widget.catUuid,
              subcatUuid: widget.subcatUuid,
              item: itemSelected,
            )
          ],
        ));
  }
}
