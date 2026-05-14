import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_input.dart';
import 'package:uuid/uuid.dart';

class CustomPricesEditor extends StatefulWidget {
  final bool isOpen;
  final dynamic price;
  final Function(Map<String, dynamic>) onSave;
  const CustomPricesEditor(
      {super.key, required this.isOpen, this.price, required this.onSave});

  @override
  State<CustomPricesEditor> createState() => _CustomPricesEditorState();
}

class _CustomPricesEditorState extends State<CustomPricesEditor> {
  late TextEditingController label;
  late TextEditingController amount;
  @override
  void initState() {
    super.initState();
    label = TextEditingController(
        text: widget.price != null ? widget.price['label'] ?? '' : '');
    amount = TextEditingController(
        text: widget.price != null ? widget.price['amount'] ?? '' : '');
  }

  void savePrice() {
    if (label.text.trim().isEmpty || amount.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              AppLocalizations.of(context)!.menu_cannot_leave_empty_fields)));
      return;
    }
    final newPrice = {
      'uuid': widget.price?['uuid'] ?? 'price-${Uuid().v4()}',
      'label': label.text.trim(),
      'amount': amount.text.trim()
    };
    widget.onSave(newPrice);
    label.clear();
    amount.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isOpen) return const SizedBox.shrink();
    final isNew = widget.price == null;
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.purple, width: 2),
          borderRadius: BorderRadius.circular(30)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          CustomMenuInput(
              controller: label,
              hintText: AppLocalizations.of(context)!.menu_enter_price_label,
              function: (_) {}),
          CustomMenuInput(
              controller: amount,
              hintText: AppLocalizations.of(context)!.menu_enter_price_amount,
              function: (_) {}),
          CustomMenuButton(
              onPressed: savePrice,
              child: isNew
                  ? AppLocalizations.of(context)!.menu_add
                  : AppLocalizations.of(context)!.menu_edit_s)
        ],
      ),
    );
  }
}
