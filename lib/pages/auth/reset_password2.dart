import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';

import '../../style/style.dart';
import '../../elements/gradient.dart';
import '../../elements/appbar.dart';
import '../../elements/otpinput.dart';
import '../../api/auth_service.dart';
import '../../pages/auth/reset_password3.dart';

class ResetPass2 extends StatefulWidget {
  const ResetPass2({super.key});
  @override
  State<ResetPass2> createState() => _ResetPass2State();
}

class _ResetPass2State extends State<ResetPass2> {
  final authService = AuthService();
  void resetPass3(String resetId, String otp) {
    authService.resetPass2(resetId, otp);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ResetPass3()));
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
                  AppLocalizations.of(context)!.enter_your_otp,
                  style: appTextStyle(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 168, 168, 168),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getResponsivePadding(context)),
                  child: CustomOtp(function: (otp) {
                    print("OTP entered: $otp");
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
