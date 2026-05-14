import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moonlinks/utils/locale_hive.dart';

final localeProvider =
    StateNotifierProvider<LocaleNotifier, Locale>((_) => LocaleNotifier());

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadLocale();
  }
  late Box _box;

  Future<void> _loadLocale() async {
    _box = getLocaleBox();

    final savedLang = _box.get('lang');

    if (savedLang != null) {
      state = Locale(savedLang);
    }
  }

  Future<void> setLocale(String lang) async {
    _box = getLocaleBox();

    state = Locale(lang);

    await _box.put('lang', lang);
  }
}
