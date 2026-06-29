import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/catalogue/elements/item/parameter_values/catalogue_parameter_editor.dart';
import 'package:moonlinks/catalogue/utils/catalogue_provider.dart';
import 'package:moonlinks/elements/appbar.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_input.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';
import 'package:uuid/uuid.dart';

class CatalogueItemEditor extends ConsumerStatefulWidget {
  final String categoryUuid;
  final String subcategoryUuid;
  final dynamic item;
  const CatalogueItemEditor(
      {super.key,
      required this.item,
      required this.categoryUuid,
      required this.subcategoryUuid});

  @override
  ConsumerState<CatalogueItemEditor> createState() =>
      _CatalogueItemEditorState();
}

class _CatalogueItemEditorState extends ConsumerState<CatalogueItemEditor> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController defaultPriceController;
  late int currentIndexOrder;
  bool isParameterEditorOpen = false;
  String? chosenParameter;
  dynamic itemInfo;
  @override
  void initState() {
    super.initState();
    itemInfo = widget.item;
    titleController = TextEditingController(
        text: widget.item != null ? widget.item!['title'] ?? '' : '');

    descriptionController = TextEditingController(
        text: widget.item != null ? widget.item!['description'] ?? '' : '');
    defaultPriceController = TextEditingController(
        text: widget.item != null ? widget.item!['main_price'] ?? '' : '');
    if (widget.item == null) {
      final items = ref
          .read(catalogueProvider.notifier)
          .searchSubCategoryNode(widget.categoryUuid, widget.subcategoryUuid);
      currentIndexOrder = items['items']?.length ?? 0;
    } else {
      currentIndexOrder = widget.item!['display_order'];
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    defaultPriceController.dispose();
    super.dispose();
  }

  void _addParameter() {}
  void _addVAlue(String parameterId) {}
  @override
  Widget build(BuildContext context) {
    final uuid = widget.item?['uuid'] ?? 'item-${const Uuid().v4()}';
    final isNew = widget.item == null;
    return Scaffold(
        appBar: CustomAppBar(haveIcon: true),
        body: Stack(children: [
          Column(children: [
            Expanded(
                child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(children: [
                      const SizedBox(height: 15),
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
                      const SizedBox(height: 10),
                      CustomMenuInput(
                        controller: titleController,
                        hintText: AppLocalizations.of(context)!.item_name,
                        function: (_) {},
                      ),
                      const SizedBox(height: 10),
                      CustomMenuInput(
                          controller: descriptionController,
                          hintText:
                              AppLocalizations.of(context)!.item_description,
                          function: (_) {}),
                      const SizedBox(height: 10),
                      CustomMenuInput(
                          controller: defaultPriceController,
                          hintText:
                              AppLocalizations.of(context)!.item_default_price,
                          function: (_) {}),
                      const SizedBox(height: 10),
                      CustomMenuButton(
                          child:
                              AppLocalizations.of(context)!.item_add_parameter,
                          onPressed: () => setState(() {
                                chosenParameter = null;
                                isParameterEditorOpen = true;
                              })),
                      const SizedBox(height: 10),
                      Column(
                          children: itemInfo['pricing_config']['parameters']
                              .map<dynamic>((parameter) => {
                                    Container(
                                      child: Column(children: [
                                        Text(parameter['name']),
                                        CustomMenuButton(
                                            child: 'update',
                                            onPressed: () {
                                              setState(() {
                                                chosenParameter =
                                                    parameter['id'];
                                                isParameterEditorOpen = true;
                                              });
                                            })
                                      ]),
                                    )
                                  })
                              .toList())
                      //logic for editor
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
                          child: AppLocalizations.of(context)!.item_save,
                          onPressed: () async {
                            await ref
                                .read(catalogueProvider.notifier)
                                .addOrModifyItem(widget.categoryUuid,
                                    widget.subcategoryUuid, itemInfo);
                            Navigator.pop(context);
                          },
                          fontSize: 32,
                          fontWeight: FontWeight.w800)
                    ],
                  ),
                ),
              ),
            )
          ]),
          isParameterEditorOpen
              ? Stack(children: [
                  Positioned.fill(
                      child: GestureDetector(
                    onTap: () => setState(() {
                      isParameterEditorOpen = false;
                    }),
                    child: Container(
                      color: const Color.fromARGB(167, 197, 197, 197),
                    ),
                  )),
                  Center(
                      child: Container(
                          width:
                              context.screenWidth * (context.isWide ? .4 : .9),
                          height: 700,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 3),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 20,
                                    spreadRadius: 2)
                              ]),
                          padding: const EdgeInsets.all(16),
                          child: SingleChildScrollView(
                              child:
                                  //parameters
                                  Column(children: [
                            CatalogueParameterEditor(
                              parameters: itemInfo['pricing_config']
                                  ['parameters'],
                              chosenParameter: chosenParameter,
                              addOrUpdateParameter: _addParameter,
                            )
                          ])
                              //next editor content (banners, parameters values)
                              )))
                ])
              : const SizedBox.shrink()
        ]));
  }
}
