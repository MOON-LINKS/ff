import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';

class CustomPrice extends StatefulWidget {
  final dynamic price;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  const CustomPrice(
      {super.key,
      required this.price,
      required this.onDelete,
      required this.onEdit});

  @override
  State<CustomPrice> createState() => _CustomPriceState();
}

class _CustomPriceState extends State<CustomPrice> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(30)),
            child: Text(
              '${widget.price['label']} - ${widget.price['amount'].toString()}',
              style: TextStyle(color: Colors.white),
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
