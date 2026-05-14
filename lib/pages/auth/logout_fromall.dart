import 'package:flutter/material.dart';
import 'package:moonlinks/api/auth_service.dart';
import 'package:moonlinks/elements/appBar.dart';
import 'package:moonlinks/elements/button.dart';
import 'package:moonlinks/elements/input.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import '../../style/style.dart';
import '../../elements/gradient.dart';

class LogoutFromall extends StatefulWidget {
  const LogoutFromall({super.key});
  @override
  State<LogoutFromall> createState() => _LogoutFromallState();
}

class _LogoutFromallState extends State<LogoutFromall> {
  final key = GlobalKey<FormState>();
  final password = TextEditingController();
  final authService = AuthService();
  void logoutFromAllFct() {
    authService.logoutFromAll(password.text);
  }

  @override
  void dispose() {
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(haveIcon: true),
      body: RadialBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.logout_from_all,
                  style: appTextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.logout_from_all_opened_sessions,
                  style: appTextStyle(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 168, 168, 168),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getResponsivePadding(context)),
                    child: Form(
                        key: key,
                        child: Column(
                          children: [
                            CustomInput(
                                label: AppLocalizations.of(context)!
                                    .enter_your_password,
                                readOnly: false,
                                type: InputType.password,
                                controller: password),
                            CustomButton(
                                function: logoutFromAllFct,
                                name: AppLocalizations.of(context)!
                                    .logout_from_all)
                          ],
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
