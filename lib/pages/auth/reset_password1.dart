import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import '../../style/style.dart';
import '../../elements/gradient.dart';
import '../../elements/appbar.dart';
import 'package:moonlinks/elements/button.dart';
import 'package:moonlinks/elements/input.dart';
import '../../api/auth_service.dart';
import './reset_password2.dart';

class ResetPass1 extends StatefulWidget {
  const ResetPass1({super.key});

  @override
  State<ResetPass1> createState() => _ResetPass1State();
}

class _ResetPass1State extends State<ResetPass1> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController mail = TextEditingController();
  final authService = AuthService();
  void resetPass2() {
    if (_formKey.currentState!.validate()) {
      print("sending otp to: ${mail.text}");

      authService.resetPass1(1, mail.text);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ResetPass2()));
    }
  }

  @override
  void dispose() {
    mail.dispose();
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
                AppLocalizations.of(context)!.reset_your_password_title,
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
                          label: AppLocalizations.of(context)!.enter_your_mail,
                          readOnly: false,
                          type: InputType.email,
                          controller: mail,
                        ),
                        CustomButton(
                          function: resetPass2,
                          name: AppLocalizations.of(context)!.reset,
                        ),
                      ],
                    ),
                  ))
            ])))));
  }
}
