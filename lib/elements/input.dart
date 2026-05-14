import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';

enum InputType { text, email, password }

class CustomInput extends StatelessWidget {
  final String label;
  final bool readOnly;
  final InputType type;
  final TextEditingController controller;
  const CustomInput({
    super.key,
    required this.label,
    required this.readOnly,
    required this.type,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: TextFormField(
          cursorColor: Colors.white,
          controller: controller,
          readOnly: readOnly,
          obscureText: type == InputType.password,
          keyboardType: type == InputType.email
              ? TextInputType.emailAddress
              : TextInputType.text,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            /* prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            prefix: Padding(
              padding: EdgeInsets.only(right: 20),
              child: Text(
                "$label :",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ), */
            labelText: label,
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            border: OutlineInputBorder(),
            filled: false,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
          ),
          validator: /*  readOnly
              ? null
              :  */
              (value) {
            if (value == null || value.isEmpty)
              return AppLocalizations.of(context)!.field_required;

            if (type == InputType.email) {
              final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
              if (!emailRegex.hasMatch(value))
                return AppLocalizations.of(context)!.invalid_email;
            }

            if (type == InputType.password && value.length < 6) {
              return AppLocalizations.of(context)!.password_min_length;
            }

            return null;
          },
        ));
  }
}
