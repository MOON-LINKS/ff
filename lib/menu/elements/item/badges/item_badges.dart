import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_checkbox.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_input.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_title.dart';

class ItemBadges extends StatefulWidget {
  final List<dynamic>? badges;
  final Function(List<Map<String, dynamic>>)? badgeChange;

  const ItemBadges({
    super.key,
    required this.badges,
    required this.badgeChange,
  });

  @override
  State<ItemBadges> createState() => _ItemBadgesState();
}

class _ItemBadgesState extends State<ItemBadges> {
  bool isNewAdded = false;
  bool isOfferAdded = false;
  TextEditingController offerValue = TextEditingController();
  List<Map<String, dynamic>> newBadges = [];

  @override
  void initState() {
    super.initState();

    if (widget.badges != null && widget.badges!.isNotEmpty) {
      for (var e in widget.badges!) {
        switch (e['type']) {
          case 'isNew':
            isNewAdded = e['value'] ?? false;
            break;
          case 'offer':
            isOfferAdded = e['value'] ?? false;
            offerValue.text = e['percent']?.toString() ?? '';
            break;
        }
      }
    }

    _updateBadges();
  }

  void _updateBadges() {
    newBadges = [
      {"type": "isNew", "value": isNewAdded},
      {
        "type": "offer",
        "value": isOfferAdded,
        "percent": offerValue.text.isNotEmpty ? offerValue.text : null
      },
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.badgeChange?.call(newBadges);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        CustomMenuTitle(child: AppLocalizations.of(context)!.menu_badges),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomMenuTitle(child: AppLocalizations.of(context)!.menu_new_item),
            CustomMenuCheckbox(
              value: isNewAdded,
              onChanged: (bool? value) {
                setState(() => isNewAdded = value ?? false);
                _updateBadges();
              },
            ),
          ],
        ),
        Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              CustomMenuTitle(child: AppLocalizations.of(context)!.menu_offer),
              CustomMenuCheckbox(
                value: isOfferAdded,
                onChanged: (bool? value) {
                  setState(() => isOfferAdded = value ?? false);
                  _updateBadges();
                },
              )
            ]),
            if (isOfferAdded)
              CustomMenuInput(
                  controller: offerValue,
                  hintText:
                      AppLocalizations.of(context)!.menu_add_percentage_value,
                  function: (val) => _updateBadges())
          ],
        ),
      ],
    );
  }
}
