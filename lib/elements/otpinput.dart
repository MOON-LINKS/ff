import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomOtp extends StatelessWidget {
  final void Function(String) function;
  const CustomOtp({super.key, required this.function});
  @override
  Widget build(BuildContext context) {
    final TextEditingController otpController = TextEditingController();
    return Padding(
        padding: const EdgeInsets.only(top: 50),
        child: PinCodeTextField(
          appContext: context,
          length: 6,
          controller: otpController,
          keyboardType: TextInputType.number,
          autoFocus: true,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(8),
            fieldHeight: 50,
            fieldWidth: 50,
            activeFillColor: Colors.white,
            selectedFillColor: Colors.grey[200],
            inactiveFillColor: Colors.grey[300],
          ),
          onChanged: (value) {},
          onCompleted: (value) {
            function(value);
          },
        ));
  }
}
