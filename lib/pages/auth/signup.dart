import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import '../../style/style.dart';
import '../../elements/input.dart';
import '../../elements/button.dart';
import '../../elements/terms_check.dart';
import '../../api/auth_service.dart';
import './otp_verification.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final authService = AuthService();
  final formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool acceptedTerms = false;
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<dynamic> registerTap() async {
    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.registering)),
      );
    }
    if (!acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context)!.accept_term_and_conditions)),
      );
      return;
    }
    try {
      final data = await authService.register(
          true, name.text, email.text, password.text);
      if (data != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerification(
              verificationId: data['verificationId'],
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        AppLocalizations.of(context)!.sign_up_for_new_acc,
        style: appTextStyle(
          fontSize: 15,
          color: const Color.fromARGB(255, 168, 168, 168),
          fontWeight: FontWeight.bold,
        ),
      ),
      Form(
          key: formKey,
          child: Column(
            children: [
              CustomInput(
                  label: AppLocalizations.of(context)!.name,
                  readOnly: false,
                  type: InputType.text,
                  controller: name),
              CustomInput(
                  label: AppLocalizations.of(context)!.email,
                  readOnly: false,
                  type: InputType.email,
                  controller: email),
              CustomInput(
                  label: AppLocalizations.of(context)!.password,
                  readOnly: false,
                  type: InputType.password,
                  controller: password),
              TermsCheckbox(
                value: acceptedTerms,
                onChanged: (val) {
                  setState(() {
                    acceptedTerms = val ?? false;
                  });
                },
              ),
              CustomButton(
                  function: registerTap,
                  name: AppLocalizations.of(context)!.register)
            ],
          ))
    ]);
  }
}
