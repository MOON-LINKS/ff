import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

String getClientType() {
  if (kIsWeb) return 'web';
  if (Platform.isAndroid) return 'app';
  if (Platform.isIOS) return 'app';
  if (Platform.isWindows) return 'desktop';
  if (Platform.isLinux) return 'desktop';
  if (Platform.isMacOS) return 'desktop';
  return 'unknown';
}
