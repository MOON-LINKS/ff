import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/item/prices/custom_price.dart';
import 'package:moonlinks/menu/elements/item/prices/custom_prices_editor.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';

class ItemPrices extends StatefulWidget {
  final dynamic prices;
  final Function(List<Map<String, dynamic>>)? onPriceChange;
  const ItemPrices({super.key, required this.prices, this.onPriceChange});

  @override
  State<ItemPrices> createState() => _ItemPricesState();
}

class _ItemPricesState extends State<ItemPrices> {
  bool isEditorOpen = false;
  Map<String, dynamic>? selectedPrice;
  List<Map<String, dynamic>> editedPrices = [];
  @override
  void initState() {
    super.initState();
    editedPrices = widget.prices != null
        ? List<Map<String, dynamic>>.from(
            (widget.prices as List).map((e) => Map<String, dynamic>.from(e)))
        : [];
    if (widget.onPriceChange != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onPriceChange!(editedPrices);
      });
    }
  }

  void addNewPrice() {
    setState(() {
      selectedPrice = null;
      isEditorOpen = !isEditorOpen;
    });
  }

  void onSavePrice(Map<String, dynamic> newPrice) {
    setState(() {
      if (selectedPrice != null) {
        final index =
            editedPrices.indexWhere((t) => t['uuid'] == newPrice['uuid']);
        if (index != -1) editedPrices[index] = newPrice;
      } else {
        editedPrices.add(newPrice);
      }
      isEditorOpen = false;
      selectedPrice = null;

      widget.onPriceChange!(editedPrices);
    });
  }

  void onDeletePrice(String id) {
    setState(() {
      editedPrices.removeWhere((e) => e['uuid'] == id);
      widget.onPriceChange!(editedPrices);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        CustomMenuTitle(child: AppLocalizations.of(context)!.menu_prices),
        CustomMenuButton(
            onPressed: addNewPrice, child: isEditorOpen ? '-' : '+'),
        CustomPricesEditor(
          key: ValueKey(selectedPrice != null ? selectedPrice!['uuid'] : 'new'),
          isOpen: isEditorOpen,
          onSave: onSavePrice,
          price: selectedPrice,
        ),
        editedPrices.isEmpty
            ? const SizedBox.shrink()
            : Column(
                children: editedPrices.map<Widget>((itemPrice) {
                  return CustomPrice(
                      price: itemPrice,
                      onDelete: () => onDeletePrice(itemPrice['uuid']),
                      onEdit: () {
                        setState(() {
                          selectedPrice = Map<String, dynamic>.from(itemPrice);
                          isEditorOpen = true;
                        });
                      });
                }).toList(),
              )
      ],
    );
  }
}
