import 'package:flutter/material.dart';
import 'package:moonlinks/api/service.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/web/webview_screen.dart';

class MenuAddOnCalculator extends StatefulWidget {
  final double quantity;
  final String itemId;
  final String status;
  final Function(String) changedStatus;
  const MenuAddOnCalculator(
      {super.key,
      required this.quantity,
      required this.itemId,
      required this.status,
      required this.changedStatus});

  @override
  State<MenuAddOnCalculator> createState() => _MenuAddOnCalculatorState();
}

class _MenuAddOnCalculatorState extends State<MenuAddOnCalculator> {
  late double newQuantity;
  late String stripeItemId;
  final serviceAPI = ServiceAPI();
  final max = 10000.0;
  void newQuantityVal(double quantity, String itemId) {
    setState(() {
      newQuantity = quantity;
      stripeItemId = itemId;
    });
  }

  void checkout(int qty, String itemId) async {
    if (widget.itemId == '' && widget.quantity == 0) {
      final response = await serviceAPI.payMenuAddOns(qty);
      final url = response['url'];
      openExternalUrl(context, url);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Colors.black,
                title: Text(AppLocalizations.of(context)!.confirm_add_on,
                    style: TextStyle(color: Colors.white)),
                content:
                    Text(AppLocalizations.of(context)!.confirm_add_on_message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(AppLocalizations.of(context)!.cancel,
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      final response =
                          await serviceAPI.upgradeMenuAddOn(itemId, qty);
                      final url = response['url'];
                      openExternalUrl(context, url);
                    }, // Confirm
                    child: Text(AppLocalizations.of(context)!.continue_action,
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
              ));
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

    return Container(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          Row(children: [Text(AppLocalizations.of(context)!.addon_price_rule)]),
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
                      style: TextStyle(color: Colors.purple, fontSize: 18),
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
                      style: TextStyle(color: Colors.purple, fontSize: 18),
                      '+')),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Text(
                  '${AppLocalizations.of(context)!.total_add_on_is} : ${newQuantity.toInt()}',
                  style: TextStyle(color: Colors.purple, fontSize: 18)),
              Column(children: [
                CustomMenuButton(
                    child: widget.quantity != 0
                        ? AppLocalizations.of(context)!.update_add
                        : AppLocalizations.of(context)!.add_on,
                    onPressed: () {
                      checkout((newQuantity / 100).toInt(), stripeItemId);
                    }),
                Text(
                    '${AppLocalizations.of(context)!.total_price}: \$ ${newQuantity.toInt() / 100 * 2}',
                    style: TextStyle(color: Colors.black))
              ])
            ],
          ),
          /* Column(children: [
            Row(children: [
              Text('Auto-Renew',
                  style: TextStyle(color: Colors.black, fontSize: 12)),
              Switch(
                value: widget.status == 'cancelled',
                onChanged: (bool value) async {
                  final bool autoRenew = value;

                  try {
                    await serviceAPI.setState(() {});
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
                activeColor: Colors.purple,
                activeTrackColor: const Color.fromARGB(85, 155, 39, 176),
                inactiveThumbColor: Colors.blueGrey,
                inactiveTrackColor: Colors.grey,
              )
            ]),
          ]) */
        ]));
  }
}
