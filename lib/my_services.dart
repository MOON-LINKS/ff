import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/api/auth_service.dart';
import 'package:moonlinks/api/pay.dart';
import 'package:moonlinks/catalogue/elements/catalogue_add_ons.dart';
import 'package:moonlinks/catalogue/pages/catalogue_main.dart';
import 'package:moonlinks/elements/add_ons.dart';
import 'package:moonlinks/elements/upgradable.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/functions/secure_storage.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/pages/menu_main.dart';
import 'package:moonlinks/pages/services/catalogue.dart';
import 'package:moonlinks/pages/services/menu.dart';
import 'package:moonlinks/utils/subscribed_services_riverpod.dart';

class MyServices extends ConsumerStatefulWidget {
  const MyServices({super.key});

  @override
  ConsumerState<MyServices> createState() => _MyServicesState();
}

class _MyServicesState extends ConsumerState<MyServices> {
  final paymentAPI = Pay();
  late String cred;
  bool isLogged = false;
  bool cancelOpen = false;
  bool isOpen = false;
  bool _isRecharging = false;
  dynamic planChosen;
  Future<void> getUserSubscription() async {
    String? token = await readToken();
    if (token != null) {
      final user = await AuthService().getUserInfo(token);
      setState(() {
        cred = user["user"]["cred"];
        isLogged = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserSubscription();
  }

  @override
  Widget build(BuildContext context) {
    final services = ref.watch(subServicesProvider);
    return Scaffold(
        body: isLogged
            ? services.isNotEmpty
                ? Padding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 25),
                    child: Stack(children: [
                      Center(
                          child: SingleChildScrollView(
                              child: Column(
                                  spacing: 15,
                                  children: services.map<Widget>((plan) {
                                    return Container(
                                        width: context.isWide
                                            ? context.screenWidth * .4
                                            : context.screenWidth * .9,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: Colors.white),
                                        child: Column(
                                          children: [
                                            Column(children: [
                                              Text(plan['name'],
                                                  style: TextStyle(
                                                      color: Colors.purple,
                                                      fontSize: 18)),
                                              Text(
                                                  plan['end_date']
                                                      .split('T')
                                                      .first,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12)),
                                            ]),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                plan['is_active'] == 1
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => plan[
                                                                        'name']
                                                                    .toString()
                                                                    .toLowerCase()
                                                                    .contains(
                                                                        'menu generator')
                                                                ? MenuMain(
                                                                    subscribedServiceId:
                                                                        plan[
                                                                            'subscribedserviceId'],
                                                                  )
                                                                : CatalogueMain(
                                                                    subscribedServiceId:
                                                                        plan[
                                                                            'subscribedserviceId'],
                                                                  )))
                                                    : ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .past_due)));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 10),
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 230, 88, 255),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadiusGeometry
                                                              .circular(30))),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .workspace,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            plan['is_active'] == 1 &&
                                                    (kIsWeb || !Platform.isIOS)
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                        CustomMenuButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                planChosen =
                                                                    plan;
                                                                isOpen = true;
                                                              });
                                                            },
                                                            child: AppLocalizations
                                                                    .of(context)!
                                                                .upgrade_plan),
                                                        const SizedBox(
                                                            width: 10),
                                                        CustomMenuButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                cancelOpen =
                                                                    !cancelOpen;
                                                              });
                                                            },
                                                            child: cancelOpen
                                                                ? AppLocalizations.of(
                                                                        context)!
                                                                    .less_info
                                                                : AppLocalizations.of(
                                                                        context)!
                                                                    .more_info),
                                                      ])
                                                : const SizedBox.shrink(),
                                            const SizedBox(height: 10),
                                            cancelOpen
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                        Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .auto_renew,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12)),
                                                        Transform.scale(
                                                            scale: .7,
                                                            child: Switch(
                                                              value: plan[
                                                                      'is_cancelled'] ==
                                                                  0,
                                                              onChanged: (bool
                                                                  value) async {
                                                                final bool
                                                                    autoRenew =
                                                                    value;

                                                                try {
                                                                  await paymentAPI
                                                                      .toggleCheckoutRenewal(
                                                                    plan[
                                                                        'subscribedserviceId'],
                                                                    plan[
                                                                        'stripe_subscription_item_id'],
                                                                    cred,
                                                                    autoRenew,
                                                                  );

                                                                  setState(() {
                                                                    plan['is_cancelled'] =
                                                                        autoRenew
                                                                            ? 0
                                                                            : 1;
                                                                  });
                                                                } catch (e) {
                                                                  debugPrint(e
                                                                      .toString());
                                                                }
                                                              },
                                                              activeColor:
                                                                  Colors.purple,
                                                              activeTrackColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      85,
                                                                      155,
                                                                      39,
                                                                      176),
                                                              inactiveThumbColor:
                                                                  Colors
                                                                      .blueGrey,
                                                              inactiveTrackColor:
                                                                  Colors.grey,
                                                            ))
                                                      ])
                                                : const SizedBox.shrink(),
                                            plan['is_active'] == 0
                                                ? plan['is_cancelled'] == 0
                                                    ? _isRecharging
                                                        ? const CircularProgressIndicator(
                                                            color:
                                                                Colors.purple)
                                                        : CustomMenuButton(
                                                            child: AppLocalizations
                                                                    .of(context)!
                                                                .recharge,
                                                            onPressed:
                                                                () async {
                                                              final hasActivePlan = services.any((s) =>
                                                                  s['name'].toString().toLowerCase().contains(plan[
                                                                              'name']
                                                                          .toString()
                                                                          .toLowerCase()
                                                                          .contains(
                                                                              'menu generator')
                                                                      ? 'menu generator'
                                                                      : 'catalogue') &&
                                                                  s['is_active'] ==
                                                                      1);

                                                              if (hasActivePlan) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  content: Text(
                                                                      AppLocalizations.of(
                                                                              context)!
                                                                          .already_have_active_plan),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .orange,
                                                                ));
                                                                return;
                                                              }
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder: (_) =>
                                                                    AlertDialog(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16)),
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .payment,
                                                                      color: Colors
                                                                          .purple,
                                                                      size: 48),
                                                                  title: Text(
                                                                    AppLocalizations.of(
                                                                            context)!
                                                                        .recharge_confirm_title,
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  content: Text(
                                                                    AppLocalizations.of(
                                                                            context)!
                                                                        .recharge_confirm_description,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black54),
                                                                  ),
                                                                  actionsAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(context),
                                                                      child:
                                                                          Text(
                                                                        AppLocalizations.of(context)!
                                                                            .cancel,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black54),
                                                                      ),
                                                                    ),
                                                                    ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                            Colors.purple,
                                                                        foregroundColor:
                                                                            Colors.white,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        Navigator.pop(
                                                                            context);
                                                                        setState(() =>
                                                                            _isRecharging =
                                                                                true);
                                                                        try {
                                                                          final response =
                                                                              await paymentAPI.rechargeService(plan['subscribedserviceId']);
                                                                          if (context
                                                                              .mounted) {
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                              content: Text(response['message'] ?? 'Recharged successfully'),
                                                                              backgroundColor: Colors.green,
                                                                            ));
                                                                          }
                                                                        } catch (e) {
                                                                          if (context
                                                                              .mounted) {
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                              content: Text(AppLocalizations.of(context)!.delete_account_error),
                                                                              backgroundColor: Colors.red,
                                                                            ));
                                                                          }
                                                                        } finally {
                                                                          if (mounted) {
                                                                            setState(() =>
                                                                                _isRecharging = false);
                                                                          }
                                                                        }
                                                                      },
                                                                      child: Text(
                                                                          AppLocalizations.of(context)!
                                                                              .recharge_confirm_button),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          )
                                                    : CustomMenuButton(
                                                        child:
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .resubscribe,
                                                        onPressed: () {
                                                          final hasActivePlan = services.any((s) =>
                                                              s['name']
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .contains(plan[
                                                                              'name']
                                                                          .toString()
                                                                          .toLowerCase()
                                                                          .contains(
                                                                              'menu generator')
                                                                      ? 'menu generator'
                                                                      : 'catalogue') &&
                                                              s['is_active'] ==
                                                                  1);

                                                          if (hasActivePlan) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .already_have_active_plan),
                                                              backgroundColor:
                                                                  Colors.orange,
                                                            ));
                                                            return;
                                                          }
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => plan[
                                                                              'name']
                                                                          .toString()
                                                                          .toLowerCase()
                                                                          .contains(
                                                                              'menu generator')
                                                                      ? const Menu()
                                                                      : const Catalogue()));
                                                        })
                                                : const SizedBox.shrink(),
                                            plan['plan_type']
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains('premium')
                                                ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                        const SizedBox(
                                                            height: 15),
                                                        Divider(
                                                            color:
                                                                Colors.purple,
                                                            height: 5,
                                                            thickness: 3),
                                                        // Menu premium plan
                                                        plan['name']
                                                                    .toString()
                                                                    .toLowerCase()
                                                                    .contains(
                                                                        'menu') &&
                                                                plan['plan_type']
                                                                    .toString()
                                                                    .toLowerCase()
                                                                    .contains(
                                                                        'premium')
                                                            ? Column(children: [
                                                                const SizedBox(
                                                                    height: 15),

                                                                AddOns() // ✅ menu
                                                              ])
                                                            :
                                                            // Catalogue premium plan
                                                            plan['name']
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            'catalogue') &&
                                                                    plan['plan_type']
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            'premium')
                                                                ? Column(
                                                                    children: [
                                                                        const SizedBox(
                                                                            height:
                                                                                15),

                                                                        CatalogueAddOns() // ✅ catalogue
                                                                      ])
                                                                : const SizedBox
                                                                    .shrink(),
                                                      ])
                                                : const SizedBox.shrink(),
                                          ],
                                        ));
                                  }).toList()))),
                      Upgradable(
                        plan: planChosen,
                        isOpen: isOpen,
                        close: () => setState(() {
                          isOpen = false;
                          planChosen = null;
                        }),
                      )
                    ]))
                : Center(
                    child: Text(
                    AppLocalizations.of(context)!.you_are_not_subscribed_yet,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ))
            : Center(
                child: Text(AppLocalizations.of(context)!
                    .must_be_logged_in_to_access_services),
              ));
  }
}
