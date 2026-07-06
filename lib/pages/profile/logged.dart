import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/api/auth_service.dart';
import 'package:moonlinks/api/pay.dart';
import 'package:moonlinks/functions/secure_storage.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/main.dart';
import 'package:moonlinks/menu/utils/menu_provider.dart';
import 'package:moonlinks/utils/cart_riverpod.dart';
import 'package:moonlinks/utils/subscribed_services_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../style/style.dart';
import '../../elements/input.dart';
import '../../elements/button.dart';

class Logged extends ConsumerStatefulWidget {
  const Logged({super.key});
  @override
  ConsumerState<Logged> createState() => _LoggedState();
}

class _LoggedState extends ConsumerState<Logged> {
  final authService = AuthService();
  final paymentAPI = Pay();
  late TextEditingController nameController;
  late TextEditingController credController;
  int session = 0;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    credController = TextEditingController();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    final storedToken = await readToken();
    if (storedToken == null) return;

    try {
      final response = await authService.getUserInfo(storedToken);
      final user = response["user"];
      setState(() {
        session = response['user']['sessions'].length;
      });
      nameController.text = user["name"];
      credController.text = user["cred"];
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        await deleteToken();
        // navigate to login / update auth state here if needed
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.offline)),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    credController.dispose();
    super.dispose();
  }

  void logout() async {
    final token = await readToken();
    if (token != null && token.isNotEmpty) {
      await authService.logout(token);
    }
    await deleteToken();
    ref.read(subServicesProvider.notifier).removeAll();
    await ref.read(menuProvider.notifier).resetAll();
    ref.read(cartProvider.notifier).removeAll();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Main()));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getResponsivePadding(context)),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.profile,
              style: appTextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.information_about_you,
              style: appTextStyle(
                fontSize: 15,
                color: const Color.fromARGB(255, 168, 168, 168),
                fontWeight: FontWeight.bold,
              ),
            ),
            CustomInput(
                label: AppLocalizations.of(context)!.name,
                readOnly: true,
                type: InputType.text,
                controller: nameController),
            CustomInput(
                label: AppLocalizations.of(context)!.email,
                readOnly: true,
                type: InputType.email,
                controller: credController),
            CustomButton(
                function: logout, name: AppLocalizations.of(context)!.logout),
            const SizedBox(height: 15),
            (kIsWeb || !Platform.isIOS)
                ? ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                    ),
                    icon: const Icon(Icons.credit_card),
                    label: Text(
                        AppLocalizations.of(context)!.manage_payment_methods),
                    onPressed: () async {
                      try {
                        final response =
                            await paymentAPI.managePaymentMethods();
                        final url = Uri.parse(response['url']);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(AppLocalizations.of(context)!
                                .delete_account_error),
                            backgroundColor: Colors.red,
                          ));
                        }
                      }
                    },
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    ]);
  }
}
