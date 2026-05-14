import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/api/auth_service.dart';
import 'package:moonlinks/api/pay.dart';
import 'package:moonlinks/elements/add_ons.dart';
import 'package:moonlinks/elements/upgradable.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/functions/secure_storage.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/menu/pages/menu_main.dart';
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
                ? Stack(children: [
                    Center(
                        child: SingleChildScrollView(
                            child: Column(
                                children: services.map<Widget>((plan) {
                      return Container(
                          width: context.isWide
                              ? context.screenWidth * .4
                              : context.screenWidth * .9,
                          padding:
                              EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white),
                          child: Column(
                            children: [
                              Column(children: [
                                Text(plan['name'],
                                    style: TextStyle(
                                        color: Colors.purple, fontSize: 18)),
                                Text(plan['end_date'].split('T').first,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12)),
                              ]),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MenuMain(
                                                  subscribedServiceId: plan[
                                                      'subscribedserviceId'],
                                                )));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 10),
                                      backgroundColor: const Color.fromARGB(
                                          255, 230, 88, 255),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadiusGeometry.circular(
                                                  30))),
                                  child: Text(
                                    AppLocalizations.of(context)!.workspace,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20),
                                  )),
                              const SizedBox(height: 10),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomMenuButton(
                                        onPressed: () {
                                          setState(() {
                                            planChosen = plan;
                                            isOpen = true;
                                          });
                                        },
                                        child: AppLocalizations.of(context)!
                                            .upgrade_plan),
                                    const SizedBox(width: 10),
                                    CustomMenuButton(
                                        onPressed: () {
                                          setState(() {
                                            cancelOpen = !cancelOpen;
                                          });
                                        },
                                        child: cancelOpen
                                            ? AppLocalizations.of(context)!
                                                .less_info
                                            : AppLocalizations.of(context)!
                                                .more_info),
                                  ]),
                              const SizedBox(height: 10),
                              cancelOpen
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                          Text(
                                              AppLocalizations.of(context)!
                                                  .auto_renew,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12)),
                                          Transform.scale(
                                              scale: .7,
                                              child: Switch(
                                                value:
                                                    plan['is_cancelled'] == 0,
                                                onChanged: (bool value) async {
                                                  final bool autoRenew = value;

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
                                                          autoRenew ? 0 : 1;
                                                    });
                                                  } catch (e) {
                                                    debugPrint(e.toString());
                                                  }
                                                },
                                                activeColor: Colors.purple,
                                                activeTrackColor:
                                                    const Color.fromARGB(
                                                        85, 155, 39, 176),
                                                inactiveThumbColor:
                                                    Colors.blueGrey,
                                                inactiveTrackColor: Colors.grey,
                                              ))
                                        ])
                                  : const SizedBox.shrink(),
                              plan['name']
                                          .toString()
                                          .toLowerCase()
                                          .contains('menu') &&
                                      plan['plan_type']
                                          .toString()
                                          .toLowerCase()
                                          .contains('premium')
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                          const SizedBox(height: 15),
                                          Divider(
                                              color: Colors.purple,
                                              height: 5,
                                              thickness: 3),
                                          AddOns()
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
                  ])
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
