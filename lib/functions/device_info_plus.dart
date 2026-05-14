import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

final deviceInfoPlugin = DeviceInfoPlugin();
String deviceName = '';

Future<void> getDeviceInfo() async {
  String name = '';
  String type = '';

  if (kIsWeb) {
    var webInfo = await deviceInfoPlugin.webBrowserInfo;
    name = webInfo.userAgent ?? 'Unknown Web';
    type = 'Web';
  } else if (Platform.isAndroid) {
    var androidInfo = await deviceInfoPlugin.androidInfo;
    name = androidInfo.model;
    type = 'Android';
  } else if (Platform.isIOS) {
    var iosInfo = await deviceInfoPlugin.iosInfo;
    name = iosInfo.utsname.machine;
    type = 'iOS';
  } else if (Platform.isWindows) {
    var winInfo = await deviceInfoPlugin.windowsInfo;
    name = winInfo.computerName;
    type = 'Windows';
  } else if (Platform.isLinux) {
    var linuxInfo = await deviceInfoPlugin.linuxInfo;
    name = linuxInfo.name;
    type = 'Linux';
  } else if (Platform.isMacOS) {
    var macInfo = await deviceInfoPlugin.macOsInfo;
    name = macInfo.computerName;
    type = 'MacOS';
  } else {
    name = 'Unknown Device';
    type = 'Unknown';
  }
  deviceName = '$type - $name';
}
