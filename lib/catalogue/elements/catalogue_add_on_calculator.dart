import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moonlinks/catalogue/api/catalogue_api.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/web/webview_screen.dart';

class CatalogueAddOnCalculator extends StatefulWidget {
  final double quantity;
  final String itemId;
  final String status;
  final Function(String) changedStatus;
  const CatalogueAddOnCalculator(
      {super.key,
      required this.quantity,
      required this.itemId,
      required this.status,
      required this.changedStatus});

  @override
  State<CatalogueAddOnCalculator> createState() =>
      _CatalogueAddOnCalculatorState();
}

class _CatalogueAddOnCalculatorState extends State<CatalogueAddOnCalculator> {
  late double newQuantity;
  late String stripeItemId;
  bool _isProcessing = false;
  final catalogueAPI = CatalogueApi();
  final max = 10000.0;

  void newQuantityVal(double quantity, String itemId) {
    setState(() {
      newQuantity = quantity;
      stripeItemId = itemId;
    });
  }

  void checkout(int qty, String itemId) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (widget.itemId == '' && widget.quantity == 0) {
      setState(() => _isProcessing = true);
      try {
        final response = await catalogueAPI.payAddOns(qty);
        if (context.mounted) openExternalUrl(context, response['url']);
      } catch (e) {
        messenger.showSnackBar(SnackBar(
          content: Text(l10n.delete_account_error),
          backgroundColor: Colors.red,
        ));
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }
    } else {
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
                  backgroundColor: Colors.black,
                  title: Text(l10n.confirm_add_on,
                      style: TextStyle(color: Colors.white)),
                  content: Text(l10n.confirm_add_on_message),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: Text(l10n.cancel,
                          style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(dialogContext).pop();
                        setState(() => _isProcessing = true);
                        try {
                          final response =
                              await catalogueAPI.upgradeAddOn(itemId, qty);
                          if (response['url'] != null) {
                            if (context.mounted) {
                              openExternalUrl(context, response['url']);
                            }
                          } else if (response['quantity'] != null) {
                            if (mounted) setState(() => _isProcessing = false);
                            messenger.showSnackBar(SnackBar(
                              content: Text(l10n.add_on_updated_successfully),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 4),
                            ));
                          } else {
                            messenger.showSnackBar(SnackBar(
                              content: Text(response['message'] ??
                                  l10n.delete_account_error),
                              backgroundColor: Colors.red,
                            ));
                          }
                        } catch (e) {
                          messenger.showSnackBar(SnackBar(
                            content: Text(l10n.delete_account_error),
                            backgroundColor: Colors.red,
                          ));
                        } finally {
                          if (mounted) setState(() => _isProcessing = false);
                        }
                      },
                      child: Text(l10n.continue_action,
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    newQuantityVal(widget.quantity + 100, widget.itemId);
  }

  @override
  Widget build(BuildContext context) {
    final double minValue = widget.quantity.toDouble() + 100;
    final double maxValue = max;
    final int step = 100;
    final int divisions =
        ((maxValue - minValue) / step).round().clamp(1, 10000);

    return Stack(children: [
      Container(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            Row(children: [
              Text(AppLocalizations.of(context)!.addon_price_rule)
            ]),
            (kIsWeb || !Platform.isIOS)
                ? Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              if (newQuantity - 100 > widget.quantity) {
                                setState(() {
                                  newQuantity -= 100;
                                });
                              }
                            },
                            child: Text(
                                style: TextStyle(
                                    color: Colors.purple, fontSize: 18),
                                '-')),
                        Slider(
                            min: minValue,
                            max: maxValue,
                            value: newQuantity,
                            divisions: divisions,
                            label: newQuantity.toInt().toString(),
                            activeColor: Colors.purple,
                            onChanged: (value) {
                              setState(() {
                                newQuantity = value;
                              });
                            }),
                        ElevatedButton(
                            onPressed: () {
                              if (newQuantity + 100 <= max) {
                                setState(() {
                                  newQuantity += 100;
                                });
                              }
                            },
                            child: Text(
                                style: TextStyle(
                                    color: Colors.purple, fontSize: 18),
                                '+')),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Text(
                            '${AppLocalizations.of(context)!.total_add_on_is} : ${newQuantity.toInt()}',
                            style:
                                TextStyle(color: Colors.purple, fontSize: 18)),
                        Column(children: [
                          CustomMenuButton(
                              child: widget.quantity != 0
                                  ? AppLocalizations.of(context)!.update_add
                                  : AppLocalizations.of(context)!.add_on,
                              onPressed: () {
                                checkout(
                                    (newQuantity / 100).toInt(), stripeItemId);
                              }),
                          Text(
                              '${AppLocalizations.of(context)!.total_price}: \$ ${newQuantity.toInt() / 100 * 2}',
                              style: TextStyle(color: Colors.black))
                        ])
                      ],
                    )
                  ])
                : Text(AppLocalizations.of(context)!.apple_pay_disabled,
                    style: TextStyle(color: Colors.black, fontSize: 12)),
          ])),
      if (_isProcessing)
        Positioned.fill(
          child: Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
        )
    ]);
  }
}
