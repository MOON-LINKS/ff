import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openExternalUrl(BuildContext context, String url) async {
  final uri = Uri.parse(url);

  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open URL')),
    );
  }
}
