import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/api/auth_service.dart';
import 'package:moonlinks/functions/device_info_plus.dart';
import 'package:moonlinks/functions/secure_storage.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/main.dart';
import '../../style/style.dart';
import '../../elements/input.dart';
import '../../elements/button.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});
  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final authService = AuthService();
  final formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void logIn() async {
    try {
      if (formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!.checking_inputs)),
        );
        final response =
            await authService.login(email.text, password.text, deviceName);

        if (response != null && response['message'] == 'user logged in') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(AppLocalizations.of(context)!.login_successful)),
          );
          final token = response['token'];
          await addToken(token);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Main(
                      initialIndex: 2,
                    )),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(response['message'] ??
                    AppLocalizations.of(context)!.login_failed)),
          );
        }
      }
    } catch (e) {
      throw Exception('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        AppLocalizations.of(context)!.log_into_account,
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
                  label: AppLocalizations.of(context)!.email,
                  readOnly: false,
                  type: InputType.email,
                  controller: email),
              CustomInput(
                  label: AppLocalizations.of(context)!.password,
                  readOnly: false,
                  type: InputType.password,
                  controller: password),
              CustomButton(
                  function: logIn, name: AppLocalizations.of(context)!.log_in)
            ],
          ))
    ]);
  }
}
