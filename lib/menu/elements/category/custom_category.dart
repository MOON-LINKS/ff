import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/image_picker.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';
import 'package:moonlinks/menu/pages/menu_subcategories.dart';
import 'package:moonlinks/menu/utils/menu_provider.dart';

class CustomCategory extends ConsumerStatefulWidget {
  final String title;
  final String? icon;
  final String? imageUrl;
  final int hasInventoryFeature;
  final VoidCallback deleteCategory;
  final VoidCallback updateCategory;
  final int subcatNumber;
  const CustomCategory(
      {super.key,
      required this.title,
      required this.hasInventoryFeature,
      required this.icon,
      required this.imageUrl,
      required this.deleteCategory,
      required this.updateCategory,
      required this.subcatNumber});

  @override
  ConsumerState<CustomCategory> createState() => _CustomCategoryState();
}

class _CustomCategoryState extends ConsumerState<CustomCategory> {
  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(
                        menuState['payload']['design']['category-primary']),
                    border: Border.all(color: Colors.purple, width: 2),
                  ),
                  child: (widget.hasInventoryFeature == 1 &&
                          widget.imageUrl != null &&
                          widget.imageUrl!.isNotEmpty)
                      ? Image.network('$customServerName${widget.imageUrl}',
                          fit: BoxFit.cover)
                      : (widget.icon != '' && widget.icon != null)
                          ? widget.icon!.toLowerCase().endsWith('.svg')
                              ? SvgPicture.network(
                                  'https://cdn.moonlinks.me/category/${widget.icon}',
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Color(menuState['payload']['design']
                                        ['category-secondary']),
                                    BlendMode.srcIn,
                                  ),
                                )
                              : Image.network(
                                  'https://cdn.moonlinks.me/category/${widget.icon}',
                                  fit: BoxFit.cover)
                          : SvgPicture.network(
                              'https://cdn.moonlinks.me/category/cat-icon-6.svg',
                              fit: BoxFit.cover),
                )),
            Positioned(
                right: -10,
                top: 5,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.purple,
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(100)),
                  child: IconButton(
                      onPressed: widget.deleteCategory,
                      icon: Icon(
                        Icons.delete_outlined,
                        color: Colors.white,
                      )),
                ))
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            Expanded(child: CustomMenuTitle(child: widget.title)),
            CustomMenuButton(
                child: AppLocalizations.of(context)!.menu_edit,
                onPressed: widget.updateCategory)
          ],
        ),
        const SizedBox(height: 10),
        CustomMenuButton(
            onPressed: () {
              final uuid = (widget.key as ValueKey).value;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuSubcategories(
                      catUuid: uuid,
                    ),
                  ));
            },
            child: AppLocalizations.of(context)!.menu_add_view_subcategories),
        Text(
            '${AppLocalizations.of(context)!.menu_contains} ${widget.subcatNumber} ${AppLocalizations.of(context)!.menu_subcategories_count}'),
        Divider(
          color: Colors.white,
          thickness: 2,
          height: 2,
        )
      ],
    );
  }
}
