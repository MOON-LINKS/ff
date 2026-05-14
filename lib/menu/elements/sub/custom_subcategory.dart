import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';

class CustomSubcategory extends ConsumerStatefulWidget {
  final String title;
  final VoidCallback update;
  final VoidCallback delete;
  final VoidCallback navigateItems;
  final int itemNumber;
  const CustomSubcategory(
      {super.key,
      required this.title,
      required this.update,
      required this.delete,
      required this.navigateItems,
      required this.itemNumber});

  @override
  ConsumerState<CustomSubcategory> createState() => _CustomSubcategoryState();
}

class _CustomSubcategoryState extends ConsumerState<CustomSubcategory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth * (context.isWide ? .4 : .8),
      padding: EdgeInsetsGeometry.all(5),
      child: Column(
        spacing: 10,
        children: [
          Row(children: [
            Expanded(child: CustomMenuTitle(child: widget.title)),
            Container(
                decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(100)),
                child: IconButton(
                    onPressed: widget.delete,
                    icon: Icon(
                      Icons.delete_outline_outlined,
                      color: Colors.white,
                    )))
          ]),
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                CustomMenuButton(
                    onPressed: widget.update,
                    child: AppLocalizations.of(context)!.menu_edit),
                Column(
                  children: [
                    CustomMenuButton(
                        onPressed: widget.navigateItems,
                        child:
                            AppLocalizations.of(context)!.menu_add_view_items),
                    Text(
                        '${AppLocalizations.of(context)!.menu_contains} ${widget.itemNumber} ${AppLocalizations.of(context)!.menu_items_count}')
                  ],
                )
              ])
        ],
      ),
    );
  }
}
