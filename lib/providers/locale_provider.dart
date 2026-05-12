import 'package:flutter/material.dart';

/// LocaleProvider manages the current app locale for i18n support.
/// Supports English (en), Telugu (te), and Hindi (hi).
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    {'code': 'te', 'name': 'Telugu', 'nativeName': 'తెలుగు'},
    {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिंदी'},
  ];

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }

  void setLocaleByCode(String languageCode) {
    setLocale(Locale(languageCode));
  }

  String get currentLanguageName {
    return supportedLanguages.firstWhere(
      (l) => l['code'] == _locale.languageCode,
      orElse: () => {'name': 'English'},
    )['name']!;
  }
}
