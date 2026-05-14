import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/api/service.dart';
import 'package:moonlinks/elements/cart/cart.dart';
import 'package:moonlinks/elements/cart/cart_container.dart';
import 'package:moonlinks/elements/learn_service.dart';
import 'package:moonlinks/elements/price_card.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/utils/cart_riverpod.dart';
import 'package:moonlinks/utils/subscribed_services_riverpod.dart';
import '../../style/style.dart';
import '../../elements/gradient.dart';
import '../../elements/appbar.dart';

class Menu extends ConsumerStatefulWidget {
  const Menu({super.key});
  @override
  ConsumerState<Menu> createState() => MenuState();
}

class MenuState extends ConsumerState<Menu> {
  final serviceDb = ServiceAPI();
  List<dynamic> allPlans = [];
  List<dynamic> filteredPlans = [];
  bool isLoading = true;
  String timeClicked = "month";
  bool cartOpened = false;
  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    final response = await serviceDb.getServicePlan();
    final allServices = response['services'] as List;
    final filtered = allServices
        .where((item) => item['service_code'] == 'menu_generator')
        .toList();
    allPlans = filtered;
    applyFilter();
    setState(() {
      isLoading = false;
    });
  }

  void applyFilter() {
    filteredPlans =
        allPlans.where((item) => item['duration_type'] == timeClicked).toList();
  }

  void addToCart(Map<String, dynamic> item) {
    ref.read(cartProvider.notifier).addToCart(item);
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final cartServiceCodes = cart.map((p) => p['service_code']).toList();
    final subscribedServices = ref.watch(subServicesProvider);

    ServiceStatus getServiceStatus() {
      final isSubscribed = subscribedServices.any((s) =>
          s['name']
              .toString()
              .toLowerCase()
              .contains('Menu Generator'.toString().toLowerCase()) &&
          s['is_active'] == 1);

      if (isSubscribed) return ServiceStatus.subscribed;

      if (cartServiceCodes.contains('menu_generator')) {
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
                      AppLocalizations.of(context)!.menu_title,
                      style: appTextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                          horizontal: context.isWide ? 80 : 30),
                      child: Text(
                        AppLocalizations.of(context)!.menu_description,
                        textAlign: TextAlign.justify,
                        style: appTextStyle(
                          fontSize: 15,
                          color: const Color.fromARGB(255, 168, 168, 168),
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                    Padding(
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
                            ))),
                    Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: timeClicked == "month"
                                    ? Colors.purple
                                    : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.white,
                                        width: timeClicked == "month" ? 3 : 2),
                                    borderRadius:
                                        BorderRadiusGeometry.circular(30)),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                elevation: 0),
                            onPressed: () {
                              setState(() {
                                timeClicked = "month";
                                applyFilter();
                              });
                            },
                            child: Text(AppLocalizations.of(context)!.monthly,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600))),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: timeClicked == "6months"
                                    ? Colors.purple
                                    : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.white,
                                        width:
                                            timeClicked == "6months" ? 3 : 2),
                                    borderRadius:
                                        BorderRadiusGeometry.circular(30)),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                elevation: 0),
                            onPressed: () {
                              setState(() {
                                timeClicked = "6months";
                                applyFilter();
                              });
                            },
                            child: Text(
                                AppLocalizations.of(context)!.six_months,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600))),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: timeClicked == "year"
                                    ? Colors.purple
                                    : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.white,
                                        width: timeClicked == "year" ? 3 : 2),
                                    borderRadius:
                                        BorderRadiusGeometry.circular(30)),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                elevation: 0),
                            onPressed: () {
                              setState(() {
                                timeClicked = "year";
                                applyFilter();
                              });
                            },
                            child: Text(AppLocalizations.of(context)!.yearly,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600))),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsetsGeometry.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(spacing: 30, children: [
                          Text(
                            text,
                            style: TextStyle(color: Colors.green),
                          ),
                          Wrap(
                            spacing: 30,
                            runSpacing: 20,
                            alignment: WrapAlignment.center,
                            children: isLoading
                                ? ([
                                    const CircularProgressIndicator(
                                        color: Colors.white),
                                  ])
                                : filteredPlans.map<Widget>((plan) {
                                    return PriceCard(
                                      planType: plan['plan_type']
                                          .toString()
                                          .toUpperCase(),
                                      price: plan['price'],
                                      duration: plan['duration_type'],
                                      isAvailable: text == '',
                                      addToCart: () {
                                        addToCart(plan);
                                      },
                                    );
                                  }).toList(),
                          ),
                          LearnService(
                              text: AppLocalizations.of(context)!
                                  .learn_how_to_build_your_menu,
                              videos: [
                                VideoLearn(destination: 'blehNhSufwQ'),
                              ])
                        ])),
                  ],
                ),
              ),
            ),
          ),
          !cartOpened
              ? Cart(openCart: () {
                  setState(() {
                    cartOpened = true;
                  });
                })
              : CartContainer(
                  closeCart: () => setState(() {
                    cartOpened = false;
                  }),
                )
        ]));
  }
}
