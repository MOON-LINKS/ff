import 'package:flutter/material.dart';
import 'package:moonlinks/api/auth_service.dart';
import 'package:moonlinks/functions/device_info_plus.dart';
import 'package:moonlinks/functions/device_type.dart';
import 'package:moonlinks/functions/secure_storage.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/main.dart';
import '../../elements/appbar.dart';
import '../../style/style.dart';
import '../../elements/gradient.dart';
import '../../elements/otpinput.dart';

class OtpVerification extends StatefulWidget {
  final String verificationId;
  const OtpVerification({super.key, required this.verificationId});
  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          haveIcon: false,
        ),
        body: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: getResponsivePadding(context)),
            child: RadialBackground(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(children: [
                    Text(
                      AppLocalizations.of(context)!.otp_title,
                      style: appTextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .enter_the_6_digit_code_you_received,
                      style: appTextStyle(
                        fontSize: 15,
                        color: const Color.fromARGB(255, 168, 168, 168),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomOtp(function: (otp) async {
                      try {
                        final type = getClientType();
                        final response = await authService.verifyOTP(
                            otp, deviceName, widget.verificationId,
                            clientType: type);
                        if (response['message'] == 'user registered') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(AppLocalizations.of(context)!
                                    .registration_successful)),
                          );
                          print(response);
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Main()));
                          addToken(response['token']);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(AppLocalizations.of(context)!
                                    .wrong_otp_try_again_later)),
                          );
                        }
                      } catch (e) {
                        throw Exception('error: $e');
                      }
                    }),
                  ]),
                ),
              ),
            )));
  }
}
