import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hyper_app/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage with ChangeNotifier {
  Locale? _appLocale;

  Locale? get appLocale => _appLocale;

  AppLanguage() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');
    String? countryCode = prefs.getString('country_code');

    if (languageCode != null) {
      _appLocale = Locale(languageCode, countryCode);
    } else {
      _appLocale = PlatformDispatcher.instance.locale;
    }

    if (!S.delegate.supportedLocales.contains(_appLocale)) {
      _appLocale = const Locale('en', 'US'); // 设置默认语言为英语
      // _appLocale = const Locale('zh', 'CN'); // 设置默认语言为中文简体
    }

    notifyListeners();
  }

  void changeLanguage(Locale locale) async {
    _appLocale = locale;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    await prefs.setString('country_code', locale.countryCode ?? '');

    notifyListeners();
  }
}
