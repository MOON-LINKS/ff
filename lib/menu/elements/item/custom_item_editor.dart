import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/item/badges/item_badges.dart';
import 'package:moonlinks/menu/elements/item/images/item_images.dart';
import 'package:moonlinks/menu/elements/item/prices/item_prices.dart';
import 'package:moonlinks/menu/elements/item/types/item_types.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_input.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';
import 'package:moonlinks/menu/utils/menu_provider.dart';
import 'package:uuid/uuid.dart';

class CustomItemEditor extends ConsumerStatefulWidget {
  final bool isEditOpen;
  final String catUuid;
  final String subcatUuid;
  final VoidCallback closeEditor;
  final LinkedHashMap<dynamic, dynamic>? item;
  const CustomItemEditor(
      {super.key,
      required this.isEditOpen,
      required this.closeEditor,
      required this.catUuid,
      required this.subcatUuid,
      this.item});

  @override
  ConsumerState<CustomItemEditor> createState() => _CustomItemEditorState();
}

class _CustomItemEditorState extends ConsumerState<CustomItemEditor> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late bool? isActive;
  late int? currentIndexOrder;
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(
        text: widget.item != null ? widget.item!['title'] ?? '' : '');
    descriptionController = TextEditingController(
        text: widget.item != null ? widget.item!['description'] ?? '' : '');

    isActive = widget.item == null ? true : widget.item!['is_active'] == 1;
    if (widget.item == null) {
      final menuNotifier = ref.read(menuProvider.notifier);
      final items =
          menuNotifier.searchSubcategoryNode(widget.catUuid, widget.subcatUuid);
      currentIndexOrder = (items['items']?.length ?? 0);
    } else {
      currentIndexOrder = widget.item!['display_order'];
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> currentEditedTypes = [];
  List<Map<String, dynamic>> currentEditedPrices = [];
  List<Map<String, dynamic>> currentEditedBadges = [];
  String currentImageUrl = '';
  List<String> currentImages = [];
  @override
  Widget build(BuildContext context) {
    if (!widget.isEditOpen) return const SizedBox.shrink();
    final isNew = widget.item == null;
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
                width: context.screenWidth * (context.isWide ? .4 : .9),
                height: 700,
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 3),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black, blurRadius: 20, spreadRadius: 2)
                    ]),
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                    child: Column(children: [
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
                          ? AppLocalizations.of(context)!.menu_add_item_s
                          : '${AppLocalizations.of(context)!.menu_edit_item}: ${widget.item!['title']}'),
                  const SizedBox(height: 10),
                  widget.item != null
                      ? Text(
                          '${AppLocalizations.of(context)!.menu_item_order}: ${widget.item?['display_order'] + 1}',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))
                      : const SizedBox.shrink(),
                  const SizedBox(height: 10),
                  CustomMenuInput(
                    controller: titleController,
                    hintText: AppLocalizations.of(context)!.item_name,
                    function: (_) {},
                  ),
                  const SizedBox(height: 10),
                  CustomMenuInput(
                      controller: descriptionController,
                      hintText: AppLocalizations.of(context)!.item_description,
                      function: (_) {}),
                  //deactivate item
                  /*  widget.item == null
                      ? const SizedBox.shrink()
                      : Row(
                          children: [
                            CustomMenuCheckbox(
                                value: isActive!,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isActive = value;
                                  });
                                }),
                            Text(
                              isActive ?? true
                                  ? 'Item Activated'
                                  : 'Item Deactivated',
                              style: TextStyle(
                                  color: isActive ?? true
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          ],
                        ), */

                  const SizedBox(height: 10),
                  //custom type
                  ItemTypes(
                    types: widget.item?['types'] != null
                        ? List<Map<String, dynamic>>.from(
                            (widget.item!['types'] as List)
                                .map((e) => Map<String, dynamic>.from(e)))
                        : [],
                    onTypeChanged: (newTypes) {
                      setState(() {
                        currentEditedTypes = newTypes;
                      });
                    },
                  ),

                  const SizedBox(height: 10),
                  //custom price
                  ItemPrices(
                    prices: widget.item?['prices'] != null
                        ? List<Map<String, dynamic>>.from(
                            (widget.item!['prices'] as List)
                                .map((e) => Map<String, dynamic>.from(e)))
                        : [],
                    onPriceChange: (newPrices) {
                      setState(() {
                        currentEditedPrices = newPrices;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  //custom badges
                  ItemBadges(
                      badges: widget.item?['badges'] != null
                          ? List<Map<String, dynamic>>.from(
                              (widget.item!['badges'] as List)
                                  .map((e) => Map<String, dynamic>.from(e)))
                          : [],
                      badgeChange: (newBadges) {
                        setState(() {
                          currentEditedBadges = newBadges;
                        });
                      }),
                  const SizedBox(height: 10),

                  ItemImages(
                    mainImg: widget.item?['main_image_url'] != null
                        ? widget.item!['main_image_url']
                        : '',
                    images: widget.item?['images'] != null
                        ? List<String>.from(widget.item!['images'])
                        : [],
                    mainImageChange: (newImage) {
                      setState(() {
                        currentImageUrl = newImage;
                      });
                    },
                    imagesChange: (newImages) {
                      setState(() {
                        currentImages = newImages;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Divider(color: Colors.white, height: 2, thickness: 2),
                  const SizedBox(height: 10),
                  CustomMenuButton(
                    onPressed: () {
                      final title = titleController.text.trim();
                      final description = descriptionController.text.trim();
                      if (title.isEmpty ||
                          description.isEmpty ||
                          currentEditedPrices.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(AppLocalizations.of(context)!
                                .menu_item_required_fields),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 2)));
                        return;
                      }
                      final uuid =
                          widget.item?['uuid'] ?? 'item-${const Uuid().v4()}';
                      final activate = isActive ?? true ? 1 : 0;
                      final types = currentEditedTypes;
                      final prices = currentEditedPrices;
                      final badges = currentEditedBadges;
                      final mainImageUrl = currentImageUrl;
                      final imageCarousel = currentImages;
                      final displayOrder = currentIndexOrder ?? 0;
                      ref.read(menuProvider.notifier).addOrModifyItem(
                          uuid,
                          widget.subcatUuid,
                          widget.catUuid,
                          title,
                          description,
                          mainImageUrl,
                          badges,
                          activate,
                          displayOrder,
                          types,
                          prices,
                          imageCarousel);
                      titleController.clear();
                      descriptionController.clear();
                      widget.closeEditor();
                    },
                    //use state isAnyEditorOpen, and take the true and false from children editors
                    //if yes then add a scaffold alert that he should save all changes then he can save the new item
                    child: isNew
                        ? AppLocalizations.of(context)!.menu_add_close
                        : AppLocalizations.of(context)!.menu_save_close,
                  )
                ]))))
      ],
    );
  }
}
