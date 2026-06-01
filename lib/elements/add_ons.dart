import 'package:flutter/material.dart';
import 'package:moonlinks/api/service.dart';
import 'package:moonlinks/elements/menu_add_on_calculator.dart';
import 'package:moonlinks/l10n/app_localizations.dart';

class AddOns extends StatefulWidget {
  const AddOns({super.key});

  @override
  State<AddOns> createState() => _AddOnsState();
}

class _AddOnsState extends State<AddOns> {
  bool isOpen = true;
  final addOnMenu = ServiceAPI();
  dynamic addOn;
  void initializeAddOn() async {
    try {
      final response = await addOnMenu.getMenuAddOns();
      setState(() {
        addOn = response['data'];
      });
    } catch (e) {
      debugPrint('AddOn load error: $e');
      if (mounted) setState(() => addOn = {'quantity': 0});
    }
  }

  @override
  void initState() {
    super.initState();
    initializeAddOn();
  }

  @override
  Widget build(BuildContext context) {
    if (addOn == null) {
      return Center(child: CircularProgressIndicator());
    }

    if (addOn['quantity'] == null) {
      return Text(AppLocalizations.of(context)!.no_addon_data_available);
    }
    return Center(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            child: SingleChildScrollView(
                child: Column(
              spacing: 10,
              children: [
                Text(AppLocalizations.of(context)!.add_on,
                    style: TextStyle(color: Colors.purple, fontSize: 18)),
                Text(
                    '${AppLocalizations.of(context)!.images_added}: ${addOn?['quantity'] ?? 0}',
                    style: TextStyle(color: Colors.black)),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  children: [
                    Text(
                        '${AppLocalizations.of(context)!.till}: ${addOn?['ends_at']?.toString().split('T').first ?? "-"}',
                        style: TextStyle(color: Colors.black)),
                    Text(
                        '${AppLocalizations.of(context)!.status}: ${addOn?['status'] ?? "-"}',
                        style: TextStyle(color: Colors.black)),
                  ],
                ),
                MenuAddOnCalculator(
                  quantity: (addOn['quantity'] ?? 0).toDouble(),
                  itemId: (addOn['stripe_payment_intent'] ?? '') as String,
                  status: (addOn['status'] ?? '') as String,
                  changedStatus: (status) {
                    setState(() {
                      addOn['status'] = status;
                    });
                  },
                )
              ],
            ))));
  }
}
