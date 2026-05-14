import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:moonlinks/functions/context_extension.dart';
import 'package:moonlinks/l10n/app_localizations.dart';

class CustomOrderingSystem extends StatefulWidget {
  final String? phoneNumber;
  final String? countryCode;
  final String? countryISO;
  final Function(PhoneData) onNumChange;
  const CustomOrderingSystem(
      {super.key,
      required this.phoneNumber,
      required this.countryISO,
      required this.countryCode,
      required this.onNumChange});

  @override
  State<CustomOrderingSystem> createState() => _CustomOrderingSystemState();
}

class _CustomOrderingSystemState extends State<CustomOrderingSystem> {
  late TextEditingController _controller;
  String? _currentCountryISO;
  Key _fieldKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.phoneNumber ?? '');
    _currentCountryISO = widget.countryISO;
  }

  @override
  void didUpdateWidget(covariant CustomOrderingSystem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.phoneNumber != oldWidget.phoneNumber) {
      _controller.text = widget.phoneNumber ?? '';
    }

    if (widget.countryISO != oldWidget.countryISO) {
      _currentCountryISO = widget.countryISO;
      _fieldKey = UniqueKey();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth * (context.isWide ? .4 : .8),
      child: IntlPhoneField(
        key: _fieldKey,
        controller: _controller,
        cursorColor: Colors.purple,
        initialCountryCode: _currentCountryISO?.toUpperCase(),
        dropdownTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.menu_phone_number,
          labelStyle: const TextStyle(color: Colors.purple),
          hintStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Colors.black,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.purple, width: 2),
          ),
        ),
        onChanged: (phone) {
          widget.onNumChange(
            PhoneData(
              number: phone.number,
              countryCode: phone.countryCode,
              countryISO: phone.countryISOCode,
            ),
          );
        },
      ),
    );
  }
}

class PhoneData {
  final String number;
  final String countryCode;
  final String countryISO;

  PhoneData({
    required this.number,
    required this.countryCode,
    required this.countryISO,
  });
}
