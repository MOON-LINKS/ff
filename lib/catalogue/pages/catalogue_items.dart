import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/catalogue/elements/item/catalogue_item.dart';
import 'package:moonlinks/catalogue/elements/item/catalogue_item_editor.dart';
import 'package:moonlinks/catalogue/utils/catalogue_provider.dart';
import 'package:moonlinks/elements/appbar.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_tooltip.dart';

class CatalogueItems extends ConsumerStatefulWidget {
  final String catUuid;
  final String subcatUuid;
  const CatalogueItems(
      {super.key, required this.catUuid, required this.subcatUuid});

  @override
  ConsumerState<CatalogueItems> createState() => _CatalogueItemsState();
}

class _CatalogueItemsState extends ConsumerState<CatalogueItems> {
  LinkedHashMap<dynamic, dynamic>? itemSelected;

  void updateItem(LinkedHashMap<dynamic, dynamic>? item) {
    setState(() {
      itemSelected = item;
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
                      .watch(catalogueProvider.notifier)
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

    final catalogueNotifier = ref.read(catalogueProvider.notifier);
    final items = catalogueNotifier.searchSubCategoryNode(
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
    final catalogueState = ref.watch(catalogueProvider);
    final imageCounter = catalogueState['image_counter'] ?? 0;
    final imageAllowed = catalogueState['features']['total_image'] ?? 0;
    final addedOnImages =
        (catalogueState['addons_images']['status'] == 'active' ||
                (catalogueState['addons_images']['status'] == 'cancelled' &&
                    DateTime.parse(catalogueState['addons_images']['ends_at'])
                        .isAfter(DateTime.now())))
            ? catalogueState['addons_images']['quantity'] ?? 0
            : 0;
    final items = ref
        .read(catalogueProvider.notifier)
        .searchSubCategoryNode(widget.catUuid, widget.subcatUuid);
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
                                        child: CatalogueItem(
                                            item: items['items'][i],
                                            updateItem: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        CatalogueItemEditor(
                                                          item: items['items']
                                                              [i],
                                                          categoryUuid:
                                                              widget.catUuid,
                                                          subcategoryUuid:
                                                              widget.subcatUuid,
                                                        ))),
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
                                            }),
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
                                    ref
                                        .read(catalogueProvider.notifier)
                                        .updateItemsOrder(
                                            widget.subcatUuid, widget.catUuid);
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
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CatalogueItemEditor(
                                            item: null,
                                            categoryUuid: widget.catUuid,
                                            subcategoryUuid: widget.subcatUuid,
                                          )));
                            },
                            fontSize: 32,
                            fontWeight: FontWeight.w800)
                      ],
                    ),
                  ),
                ),
              )
            ]),
          ],
        ));
  }
}
