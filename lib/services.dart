import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moonlinks/elements/inapp_webview.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/menu/elements/z_custom/custom_payment_methods.dart';
import 'package:moonlinks/pages/services/catalogue.dart';
import 'package:moonlinks/pages/services/menu.dart';
import './web/webview_screen.dart';
import 'elements/gradient.dart';
import 'style/style.dart';

class Services extends StatelessWidget {
  const Services({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RadialBackground(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: context.screenWidth * (context.isWide ? 0.2 : 0.8),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.services,
                    style: appTextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.best_services_for_you,
                    style: appTextStyle(
                      fontSize: 15,
                      color: const Color.fromARGB(255, 168, 168, 168),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            ServiceBtn(
                              imagePath: "assets/icons/menu.svg",
                              title: AppLocalizations.of(context)!.menu,
                              subtitle: AppLocalizations.of(context)!.generator,
                              destination: Menu(),
                            ),
                            const SizedBox(height: 16),
                            ServiceBtn(
                              imagePath: "assets/icons/menu.svg",
                              title: AppLocalizations.of(context)!.catalogue,
                              subtitle: AppLocalizations.of(context)!.generator,
                              destination: Catalogue(),
                            ),
                            const SizedBox(height: 16),
                            ServiceBtn(
                              imagePath: "assets/icons/biopage.svg",
                              title: AppLocalizations.of(context)!.biopage,
                              subtitle:
                                  AppLocalizations.of(context)!.free_generator,
                              destination:
                                  "https://moonlinks.me/login-signup.php?error=unauthorized",
                              isWeb: true,
                            ),
                            const SizedBox(height: 16),
                            ServiceBtn(
                              imagePath: "assets/icons/qr.svg",
                              title: AppLocalizations.of(context)!.qr_code,
                              subtitle:
                                  AppLocalizations.of(context)!.free_generator,
                              destination: "https://moonlinks.me/qr/main",
                              isWeb: true,
                            ),
                            const SizedBox(height: 16),
                            ServiceBtn(
                              imagePath: "assets/icons/barcode.svg",
                              title: AppLocalizations.of(context)!.barcode,
                              subtitle:
                                  AppLocalizations.of(context)!.free_generator,
                              destination: "https://moonlinks.me/barcode/main",
                              isWeb: true,
                            ),
                            const SizedBox(height: 24),
                            (kIsWeb || !Platform.isIOS)
                                ? Text(
                                    AppLocalizations.of(context)!
                                        .secure_payments_supported_by,
                                    style: appTextStyle(
                                      fontSize: 15,
                                      color: const Color.fromARGB(
                                          255, 168, 168, 168),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(height: 10),
                            (kIsWeb || !Platform.isIOS)
                                ? CustomPaymentMethods()
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ServiceBtn extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final dynamic destination;
  final bool isWeb;
  const ServiceBtn({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.destination,
    this.isWeb = false,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.white, width: 2),
        ),
      ),
      onPressed: () {
        if (isWeb && destination is String) {
          if (kIsWeb) {
            openExternalUrl(context, destination);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => InAppWebView(
                          title: title,
                          url: destination,
                        )));
          }
        } else if (!isWeb && destination is Widget) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        }
      },
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: SvgPicture.asset(
                imagePath,
                width: 50,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Center(
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 193, 52, 218),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
