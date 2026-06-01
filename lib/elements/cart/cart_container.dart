import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/api/auth_service.dart';
import 'package:moonlinks/api/pay.dart';
import 'package:moonlinks/functions/secure_storage.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/profile.dart';
import 'package:moonlinks/utils/cart_riverpod.dart';
import 'package:moonlinks/web/webview_screen.dart';

class CartContainer extends ConsumerStatefulWidget {
  final VoidCallback closeCart;
  const CartContainer({super.key, required this.closeCart});

  @override
  ConsumerState<CartContainer> createState() => _CartContainerState();
}

class _CartContainerState extends ConsumerState<CartContainer> {
  Future<void> payNow() async {
    final storedToken = await readToken();
    if (storedToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.must_be_signed_in_to_pay),
          action: SnackBarAction(
            backgroundColor: Colors.purple,
            textColor: Colors.white,
            label: AppLocalizations.of(context)!.sign_in,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
          ),
        ),
      );
      return;
    }

    try {
      final user = await AuthService().getUserInfo(storedToken);

      if (user['user']['verified'] != 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.account_not_verified)),
        );
        return;
      }
      List<String> prices = ref
          .read(cartProvider)
          .map((e) => e['stripe_price_id'].toString())
          .toList();
      if (prices.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!.no_added_service)),
        );
        return;
      }
      final response = await Pay().createCheckout(prices);
      final url = response.data['url'];

      openExternalUrl(context, url);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void deletePlan(dynamic item) {
    ref
        .read(cartProvider.notifier)
        .removeFromCart(item['service_code'], item['plan_id']);
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    return Positioned(
        top: 0,
        bottom: 0,
        right: 0,
        width: 300,
        child: Stack(children: [
          Container(
            width: 300,
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.white),
                color: Colors.black),
            child: Column(
              spacing: 30,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: widget.closeCart,
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      )),
                ),
                Text(AppLocalizations.of(context)!.cart),
                ...cart.map<Widget>((item) {
                  return Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white),
                    child: Column(
                      children: [
                        Text(
                          item['plan_name'],
                          style: TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 20,
                          children: [
                            Text(
                              "\$ ${item['price']}",
                              style: TextStyle(color: Colors.black),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  deletePlan(item);
                                },
                                child: Icon(
                                  Icons.delete_outline_outlined,
                                  color: Colors.red,
                                ))
                          ],
                        )
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  children: [
                    /* Text(
                      'Total Price is: ',
                      style: TextStyle(color: Colors.purple),
                    ), */
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple),
                        onPressed: kIsWeb
                            ? payNow
                            : (Platform.isIOS
                                ? () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                AppLocalizations.of(context)!
                                                    .apple_pay_disabled)));
                                  }
                                : payNow),
                        child: Text(
                          AppLocalizations.of(context)!.pay_now,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ))
                  ],
                ),
              ))
        ]));
  }
}
