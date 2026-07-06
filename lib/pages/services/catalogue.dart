import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/api/service.dart';
import 'package:moonlinks/elements/appbar.dart';
import 'package:moonlinks/elements/cart/cart.dart';
import 'package:moonlinks/elements/cart/cart_container.dart';
import 'package:moonlinks/elements/gradient.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/style/style.dart';
import 'package:moonlinks/utils/cart_riverpod.dart';
import 'package:moonlinks/utils/subscribed_services_riverpod.dart';
import 'package:moonlinks/elements/price_card.dart';

class Catalogue extends ConsumerStatefulWidget {
  const Catalogue({super.key});

  @override
  ConsumerState<Catalogue> createState() => _CatalogueState();
}

class _CatalogueState extends ConsumerState<Catalogue> {
  final serviceDb = ServiceAPI();
  List<dynamic> allServices = [];
  List<dynamic> filteredServices = [];
  bool isLoading = true;
  String timeClicked = 'month';
  bool isCartOpen = false;

  @override
  void initState() {
    super.initState();
    //loadPlans();
  }

  /*  Future<void> loadPlans() async {
    final response = await serviceDb.getServicePlan();
    final services = response['services'] as List;
    final filtered = services
        .where((item) => item['service_code'] == 'catalogue_generator')
        .toList()
      ..sort((a, b) =>
          double.parse(a['price']).compareTo(double.parse(b['price'])));
    allServices = filtered;
    filterPlans();
    setState(() {
      isLoading = false;
    });
  }

  void filterPlans() {
    setState(() {
      filteredServices = allServices
          .where((item) => item['duration_type'] == timeClicked)
          .toList();
    });
  }

  void addToCart(Map<String, dynamic> item) {
    ref.read(cartProvider.notifier).addToCart(item);
  } */

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final cartServices = cart.map((p) => p['service_code']).toList();
    final subscribedServices = ref.watch(subServicesProvider);
    ServiceStatus getServiceStatus() {
      final isSubscribed = subscribedServices.any((s) =>
          s['name'].toString().toLowerCase().contains('catalogue') &&
          s['is_active'] == 1);
      if (isSubscribed) return ServiceStatus.subscribed;
      final needsRecharge = subscribedServices.any((s) =>
          s['name'].toString().toLowerCase().contains('catalogue') &&
          s['is_active'] == 0 &&
          s['is_cancelled'] == 0);
      if (needsRecharge) return ServiceStatus.recharge;
      if (cartServices.contains('catalogue_generator')) {
        return ServiceStatus.added;
      }
      return ServiceStatus.available;
    }

    ServiceStatus status = getServiceStatus();
    String text;
    switch (status) {
      case ServiceStatus.available:
        text = '';
        break;
      case ServiceStatus.added:
        text = AppLocalizations.of(context)!.this_plan_is_in_cart;
        break;
      case ServiceStatus.subscribed:
        text = AppLocalizations.of(context)!.you_are_subscribed_to_this_plan;
        break;
      case ServiceStatus.recharge:
        text = AppLocalizations.of(context)!.recharge_plan;
        break;
    }
    return Scaffold(
        appBar: const CustomAppBar(
          haveIcon: true,
        ),
        body: Stack(children: [
          RadialBackground(
              child: Center(
                  child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                Text(
                  AppLocalizations.of(context)!.catalogue,
                  style: appTextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                      horizontal: context.isWide ? 80 : 30),
                  child: Text(
                    AppLocalizations.of(context)!.catalogue_description,
                    textAlign: TextAlign.justify,
                    style: appTextStyle(
                      fontSize: 15,
                      color: const Color.fromARGB(255, 168, 168, 168),
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                /* Text(
                  'COMING SOON!',
                  style: TextStyle(fontSize: 25),
                ) */
                /*  (kIsWeb || !Platform.isIOS)
                    ? Padding(
                        padding: EdgeInsetsGeometry.symmetric(vertical: 40),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                border:
                                    Border.all(color: Colors.white, width: 3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text(
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 28),
                                  AppLocalizations.of(context)!.plans),
                            )))
                    : const SizedBox.shrink(),
                (kIsWeb || !Platform.isIOS)
                    ? Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    timeClicked = 'month';
                                    filterPlans();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: timeClicked == "month"
                                        ? Colors.purple
                                        : Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white,
                                            width:
                                                timeClicked == "month" ? 3 : 2),
                                        borderRadius:
                                            BorderRadiusGeometry.circular(30)),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    elevation: 0),
                                child: Text(
                                    AppLocalizations.of(context)!.monthly,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600))),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    timeClicked = '6months';
                                    filterPlans();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: timeClicked == "6months"
                                        ? Colors.purple
                                        : Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white,
                                            width: timeClicked == "6months"
                                                ? 3
                                                : 2),
                                        borderRadius:
                                            BorderRadiusGeometry.circular(30)),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    elevation: 0),
                                child: Text(
                                    AppLocalizations.of(context)!.six_months,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600))),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    timeClicked = 'year';
                                    filterPlans();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: timeClicked == "year"
                                        ? Colors.purple
                                        : Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white,
                                            width:
                                                timeClicked == "year" ? 3 : 2),
                                        borderRadius:
                                            BorderRadiusGeometry.circular(30)),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    elevation: 0),
                                child: Text(
                                    AppLocalizations.of(context)!.yearly,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)))
                          ])
                    : const SizedBox.shrink(),
                Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(spacing: 30, children: [
                      (kIsWeb || !Platform.isIOS)
                          ? Text(
                              text,
                              style: TextStyle(color: Colors.green),
                            )
                          : const SizedBox.shrink(),
                      Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 30,
                          runSpacing: 20,
                          children: isLoading
                              ? ([
                                  const CircularProgressIndicator(
                                      color: Colors.white)
                                ])
                              : (kIsWeb || !Platform.isIOS)
                                  ? filteredServices.map((plan) {
                                      return PriceCard(
                                        planType: plan['plan_type']
                                            .toString()
                                            .toUpperCase(),
                                        price: plan['price'],
                                        duration: plan['duration_type'],
                                        addToCart: () {
                                          addToCart(plan);
                                        },
                                        isAvailable: text == '',
                                        serviceName: 'catalogue',
                                      );
                                    }).toList()
                                  : [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .subscribe_via_web,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      )
                                    ])
                    ])) */
              ])))),
          !isCartOpen
              ? Cart(openCart: () {
                  setState(() {
                    isCartOpen = true;
                  });
                })
              : CartContainer(
                  closeCart: () => setState(() {
                    isCartOpen = false;
                  }),
                )
        ]));
  }
}
