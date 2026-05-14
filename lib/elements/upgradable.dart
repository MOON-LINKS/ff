import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/api/pay.dart';
import 'package:moonlinks/api/service.dart';
import 'package:moonlinks/functions/secure_storage.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_menu_button.dart';
import 'package:moonlinks/utils/sockets.dart';

class Upgradable extends ConsumerStatefulWidget {
  final dynamic plan;
  final bool isOpen;
  final VoidCallback close;

  const Upgradable({
    super.key,
    required this.plan,
    required this.isOpen,
    required this.close,
  });

  @override
  ConsumerState<Upgradable> createState() => _UpgradableState();
}

class _UpgradableState extends ConsumerState<Upgradable> {
  final serviceAPI = ServiceAPI();
  final payAPI = Pay();
  List<Map<String, dynamic>> plans = [];
  bool _loading = false;

  @override
  void didUpdateWidget(covariant Upgradable oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bool shouldFetch =
        widget.isOpen && widget.plan != null && oldWidget.plan != widget.plan;

    if (shouldFetch) {
      _fetchPlans();
    }
    if (!widget.isOpen && oldWidget.isOpen) {
      setState(() {
        plans.clear();
      });
    }
  }

  double roundTo2Decimals(double value) {
    return (value * 100).roundToDouble() / 100;
  }

  Future<void> _fetchPlans() async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    final response =
        await serviceAPI.getListUpgradables(widget.plan['serviceId']);

    setState(() {
      plans = List<Map<String, dynamic>>.from(
        response['upgradablePlans'] ?? [],
      );
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isOpen) return const SizedBox.shrink();

    return Positioned.fill(
        child: Center(
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(153, 158, 158, 158),
        ),
        child: Center(
          child: Column(
            children: [
              CustomMenuButton(
                onPressed: widget.close,
                child: AppLocalizations.of(context)!.close,
              ),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              else
                Column(
                  children: plans.map<Widget>((plan) {
                    final currentSub = Subscription(
                        price: double.parse(widget.plan['price']),
                        durationType: widget.plan['duration_type'],
                        endDate: DateTime.parse(widget.plan['end_date']));
                    final newPlan = Plan(
                        price: double.parse(plan['price']),
                        name: plan['name'],
                        planType: plan['plan_type']);

                    double priceToPay =
                        calculateProratedUpgrade(currentSub, newPlan);
                    priceToPay = roundTo2Decimals(priceToPay);
                    return Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                          title: Text(plan['name']),
                          subtitle: Text('\$${plan['price']}'),
                          trailing: Column(children: [
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  final response = await payAPI.upgradePlan(
                                      widget.plan['subscribedserviceId'],
                                      plan['id'],
                                      widget
                                          .plan['stripe_subscription_item_id'],
                                      plan['stripe_price_id'],
                                      priceToPay);
                                  if (response['success'] == true) {
                                    final token = await readToken();
                                    if (token != null) {
                                      updateSubServices(ref, token);
                                    }
                                  }
                                  widget.close();
                                } catch (e) {
                                  debugPrint('Upgrade failed: $e');
                                }
                              },
                              child:
                                  Text(AppLocalizations.of(context)!.upgrade),
                            ),
                            Text(
                                '${AppLocalizations.of(context)!.you_have_to_pay_more}: \$${priceToPay.toString()}')
                          ])),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    ));
  }
}

class Subscription {
  final double price;
  final String durationType;
  final DateTime endDate;

  Subscription(
      {required this.price, required this.durationType, required this.endDate});
}

class Plan {
  final double price;
  final String name;
  final String planType;

  Plan({required this.price, required this.name, required this.planType});
}

double calculateProratedUpgrade(Subscription sub, Plan newPlan,
    {int durationCount = 1}) {
  DateTime now = DateTime.now();
  DateTime endDate = sub.endDate;
  // Calculate actual start date
  DateTime startDate;
  if (sub.durationType == 'year') {
    startDate = sub.endDate.subtract(Duration(days: 365 * durationCount));
  } else if (sub.durationType == 'month') {
    startDate = DateTime(
        sub.endDate.year, sub.endDate.month - durationCount, sub.endDate.day);
  } else if (sub.durationType == '6months') {
    startDate = sub.endDate.subtract(Duration(days: 182 * durationCount));
  } else {
    startDate =
        sub.endDate.subtract(Duration(days: 30 * durationCount)); // fallback
  }

  // Total and remaining fraction
  double totalDays = endDate.difference(startDate).inDays.toDouble();
  double remainingDays = endDate.difference(now).inDays.toDouble();
  double remainingFraction = remainingDays / totalDays;
  if (remainingFraction < 0) remainingFraction = 0;

  // Prorated amounts
  double proratedNewPrice = newPlan.price * remainingFraction;
  double proratedOldPrice = sub.price * remainingFraction;

  double priceToPay = proratedNewPrice - proratedOldPrice;

  // Round to 2 decimals
  return ((priceToPay > 0 ? priceToPay : 0) * 100).roundToDouble() / 100;
}
