import 'package:flutter/material.dart';
import 'package:hyper_app/generated/l10n.dart';
import 'package:hyper_app/provider/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hyper_app/theme/colors.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final appLanguage = Provider.of<AppLanguage>(context).appLocale;
    final supportedLocales = S.delegate.supportedLocales;

    const showLanguageCode = {"en": "English", "zh": "中文"};

    return DropdownButtonHideUnderline(
      child: DropdownButton<Locale>(
        dropdownColor: backgroundBlue,
        onChanged: (Locale? locale) async {
          if (locale != null) {
            final appLanguageProvider =
                Provider.of<AppLanguage>(context, listen: false);

            appLanguageProvider.changeLanguage(locale);

            // 保存语言到缓存
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('language_code', locale.languageCode);
            await prefs.setString('country_code', locale.countryCode ?? '');

            // 在异步调用前获取当前语言
            // final weatherProvider =
            //     Provider.of<WeatherProvider>(context, listen: false);
            // final currentLocale = appLanguageProvider.appLocale;
            // if (currentLocale != null && context.mounted) {
            //   await weatherProvider.getWeatherData(context, notify: true);
            // }
          }
        },
        value: appLanguage,
        items: supportedLocales.map((Locale locale) {
          return DropdownMenuItem<Locale>(
            value: locale,
            child: Text(
              showLanguageCode[locale.languageCode]!,
            ),
          );
        }).toList(),
      ),
    );
  }
}
