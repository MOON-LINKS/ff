import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/image_picker.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_input.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_tooltip.dart';
import 'package:moonlinks/menu/utils/menu_provider.dart';
import 'package:uuid/uuid.dart';

class CustomCategoryEditor extends ConsumerStatefulWidget {
  final bool isEditOpen;
  final VoidCallback closeEditor;
  final LinkedHashMap<dynamic, dynamic>? category;
  final int hasInventoryFeature;
  const CustomCategoryEditor({
    super.key,
    required this.isEditOpen,
    required this.closeEditor,
    required this.hasInventoryFeature,
    this.category,
  });

  @override
  ConsumerState<CustomCategoryEditor> createState() =>
      _CustomCategoryEditorState();
}

class _CustomCategoryEditorState extends ConsumerState<CustomCategoryEditor> {
  late final TextEditingController titleController;
  late String? iconKey;
  late String? imageUrl;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(
        text: widget.category != null ? widget.category!['title'] ?? '' : '');
    iconKey = widget.category != null ? widget.category!['icon_key'] ?? '' : '';
    imageUrl = (widget.category != null && widget.hasInventoryFeature == 1)
        ? (widget.category!['image_url'] != null)
            ? widget.category!['image_url']
            : null
        : null;
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await customPickImage(context, 1);
    setState(() {
      isLoading = true;
    });
    setState(() {
      isLoading = false;
      imageUrl = picked;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEditOpen) return const SizedBox.shrink();
    final menuState = ref.watch(menuProvider);
    final images = List<String>.from(menuState['assets']['category']);
    final isNew = widget.category == null;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.closeEditor,
            child: Container(
              color: const Color.fromARGB(50, 197, 197, 197),
            ),
          ),
        ),

        // Centered editor
        Center(
          child: Container(
            width: 400,
            height: 500,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: widget.closeEditor,
                  ),
                ),
                CustomMenuTitle(
                    child: isNew
                        ? AppLocalizations.of(context)!.menu_add_category_title
                        : AppLocalizations.of(context)!
                            .menu_edit_category_title),
                const SizedBox(height: 20),
                CustomMenuInput(
                  controller: titleController,
                  hintText: AppLocalizations.of(context)!.menu_category_name,
                  function: (_) {},
                ),
                const SizedBox(height: 20),
                Container(
                    width: context.screenWidth * .3,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.purple, width: 2),
                    ),
                    child: DropdownButtonFormField<String>(
                        alignment: Alignment.center,
                        isDense: false,
                        itemHeight: 48,
                        value: images.contains(iconKey) ? iconKey : null,
                        items: images.map((fileName) {
                          final isSvg = fileName.toLowerCase().endsWith('.svg');
                          final url =
                              'https://cdn.moonlinks.me/category/$fileName';
                          return DropdownMenuItem<String>(
                              value: fileName,
                              child: SizedBox(
                                  height: 48,
                                  child: Center(
                                    child: isSvg
                                        ? SvgPicture.network(
                                            url,
                                            width: 48,
                                            height: 48,
                                            fit: BoxFit.contain,
                                            colorFilter: ColorFilter.mode(
                                              Color(menuState['payload']
                                                      ['design']
                                                  ['category-secondary']),
                                              BlendMode.srcIn,
                                            ),
                                          )
                                        : Image.network(
                                            url,
                                            width: 48,
                                            height: 48,
                                            fit: BoxFit.contain,
                                          ),
                                  )));
                        }).toList(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isCollapsed: true,
                        ),
                        onChanged: (value) => setState(() {
                              iconKey = value;
                            }),
                        icon: Icon(Icons.arrow_drop_down_circle_outlined,
                            color: Colors.purple),
                        focusColor: Colors.purple)),
                //list of assets
                const SizedBox(height: 20),
                //image choosing (based on feature)
                widget.hasInventoryFeature == 1
                    ? Column(children: [
                        imageUrl != null
                            ? Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.network(
                                        '$customServerName$imageUrl',
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      )),
                                  imageUrl == null
                                      ? const SizedBox.shrink()
                                      : Positioned(
                                          right: -20,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.purple,
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      imageUrl = null;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons
                                                        .delete_outline_rounded,
                                                    color: Colors.white,
                                                  ))))
                                ],
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(height: 5),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 10,
                            children: [
                              CustomMenuButton(
                                  onPressed: _pickImage,
                                  child: imageUrl != null
                                      ? AppLocalizations.of(context)!
                                          .menu_replace_image
                                      : AppLocalizations.of(context)!
                                          .menu_add_image),
                              CustomMenuTooltip(
                                  message: AppLocalizations.of(context)!
                                      .menu_image_priority_hint)
                            ])
                      ])
                    : Row(
                        children: [
                          Text(AppLocalizations.of(context)!
                              .menu_upgrade_for_images)
                        ],
                      ),
                const SizedBox(height: 20),
                CustomMenuButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    //add here || title existed
                    if (title.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!
                              .menu_category_name_required),
                          backgroundColor: Colors.redAccent,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    final uuid =
                        widget.category?['uuid'] ?? 'cat-${const Uuid().v4()}';

                    ref.read(menuProvider.notifier).addOrModifyCategory(
                          uuid,
                          title,
                          iconKey,
                          imageUrl,
                        );
                    titleController.clear();
                    widget.closeEditor();
                  },
                  child: isNew
                      ? AppLocalizations.of(context)!.menu_add_close
                      : AppLocalizations.of(context)!.menu_save_close,
                ),
              ],
            )),
          ),
        ),
      ],
    );
  }
}
