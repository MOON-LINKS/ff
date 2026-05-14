import 'package:flutter/material.dart';
import 'package:moonlinks/elements/button.dart';
import 'package:moonlinks/elements/input.dart';
import 'package:moonlinks/l10n/app_localizations.dart';

import '../../style/style.dart';
import '../../elements/gradient.dart';
import '../../elements/appbar.dart';
import '../../api/auth_service.dart';

class ResetPass3 extends StatefulWidget {
  const ResetPass3({super.key});
  @override
  State<ResetPass3> createState() => _ResetPass3State();
}

class _ResetPass3State extends State<ResetPass3> {
  final authService = AuthService();
  String token = '';
  void resetPass3() {
    if (pass1.text == pass2.text) authService.resetPass3(pass1.text, token);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController pass1 = TextEditingController();
  final TextEditingController pass2 = TextEditingController();

  @override
  void dispose() {
    pass1.dispose();
    pass2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          haveIcon: true,
        ),
        body: RadialBackground(
            child: Center(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
              Text(
                AppLocalizations.of(context)!.reset_your_password,
                style: appTextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.enter_your_new_password,
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
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomInput(
                          label: AppLocalizations.of(context)!
                              .enter_your_new_password,
                          readOnly: false,
                          type: InputType.password,
                          controller: pass1,
                        ),
                        CustomInput(
                          label: AppLocalizations.of(context)!
                              .re_enter_your_password,
                          readOnly: false,
                          type: InputType.password,
                          controller: pass2,
                        ),
                        CustomButton(
                          function: resetPass3,
                          name: AppLocalizations.of(context)!.reset,
                        ),
                      ],
                    ),
                  ))
            ])))));
  }
}
