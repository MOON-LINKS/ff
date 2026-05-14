import 'package:flutter/material.dart';
import 'package:moonlinks/l10n/app_localizations.dart';

class TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const TermsCheckbox(
      {super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Text(
        AppLocalizations.of(context)!.i_accept_terms_and_conditions,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.purple,
      checkColor: Colors.white,
    );
  }
}
