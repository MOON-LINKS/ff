import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';

class CustomType extends StatefulWidget {
  final dynamic itemType;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  const CustomType(
      {super.key,
      required this.itemType,
      required this.onEdit,
      required this.onDelete});

  @override
  State<CustomType> createState() => _CustomTypeState();
}

class _CustomTypeState extends State<CustomType> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
                color: Color(widget.itemType['backColor']),
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(30)),
            child: Text(
              widget.itemType['title'],
              style: TextStyle(color: Color(widget.itemType['textColor'])),
            )),
        Row(
          spacing: 10,
          children: [
            CustomMenuButton(
                onPressed: widget.onEdit,
                child: AppLocalizations.of(context)!.menu_update),
            IconButton(
                onPressed: widget.onDelete,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.purple,
                ))
          ],
        )
      ],
    );
  }
}
