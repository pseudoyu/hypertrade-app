// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `ChewSky`
  String get appTitle {
    return Intl.message(
      'ChewSky',
      name: 'appTitle',
      desc: 'The title of the application',
      args: [],
    );
  }

  /// `About Us \nWill be like a rainbow after the rain?`
  String get aboutus {
    return Intl.message(
      'About Us \nWill be like a rainbow after the rain?',
      name: 'aboutus',
      desc: '',
      args: [],
    );
  }

  /// `You are the huge ocean and I am the rain falling on you. Do you think this is love? I opened my hands, but I only hugged the wind. Could this be love? You see a rainbow appears in the sky after the rain. Could this be love? The dark clouds always hang over my head. Do you think this is love? When I am wandering with infinite thoughts, I will always meet you. Do you think this is love? I don’t know who gave me a tearful dream at night. Could it be love? when you have insomnia, go out for a walk. The stars are blinking. Is this love? What is love? Is it deeper than death? Will it last longer than the stars? Will it be gentler than the breeze? Will it be more gorgeous and confusing than a rainbow?`
  String get sometalk {
    return Intl.message(
      'You are the huge ocean and I am the rain falling on you. Do you think this is love? I opened my hands, but I only hugged the wind. Could this be love? You see a rainbow appears in the sky after the rain. Could this be love? The dark clouds always hang over my head. Do you think this is love? When I am wandering with infinite thoughts, I will always meet you. Do you think this is love? I don’t know who gave me a tearful dream at night. Could it be love? when you have insomnia, go out for a walk. The stars are blinking. Is this love? What is love? Is it deeper than death? Will it last longer than the stars? Will it be gentler than the breeze? Will it be more gorgeous and confusing than a rainbow?',
      name: 'sometalk',
      desc: '',
      args: [],
    );
  }

  /// `Feels Like`
  String get feelsLike {
    return Intl.message(
      'Feels Like',
      name: 'feelsLike',
      desc: 'Feels Like temperature',
      args: [],
    );
  }

  /// `Precipitation`
  String get precipitation {
    return Intl.message(
      'Precipitation',
      name: 'precipitation',
      desc: 'Precipitation',
      args: [],
    );
  }

  /// `UV Index`
  String get uvIndex {
    return Intl.message(
      'UV Index',
      name: 'uvIndex',
      desc: 'UV Index',
      args: [],
    );
  }

  /// `Wind`
  String get wind {
    return Intl.message(
      'Wind',
      name: 'wind',
      desc: 'Wind',
      args: [],
    );
  }

  /// `Humidity`
  String get humidity {
    return Intl.message(
      'Humidity',
      name: 'humidity',
      desc: 'Humidity',
      args: [],
    );
  }

  /// `Cloudiness`
  String get cloudiness {
    return Intl.message(
      'Cloudiness',
      name: 'cloudiness',
      desc: 'Cloudiness',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: 'Today',
      args: [],
    );
  }

  /// `Low`
  String get low {
    return Intl.message(
      'Low',
      name: 'low',
      desc: 'Low (UV Index)',
      args: [],
    );
  }

  /// `Medium`
  String get medium {
    return Intl.message(
      'Medium',
      name: 'medium',
      desc: 'Medium (UV Index)',
      args: [],
    );
  }

  /// `High`
  String get high {
    return Intl.message(
      'High',
      name: 'high',
      desc: 'High (UV Index)',
      args: [],
    );
  }

  /// `Very High`
  String get veryHigh {
    return Intl.message(
      'Very High',
      name: 'veryHigh',
      desc: 'Very High (UV Index)',
      args: [],
    );
  }

  /// `Extreme`
  String get extreme {
    return Intl.message(
      'Extreme',
      name: 'extreme',
      desc: 'Extreme (UV Index)',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
      desc: 'Unknown',
      args: [],
    );
  }

  /// `Thunderstorm`
  String get thunderstorm {
    return Intl.message(
      'Thunderstorm',
      name: 'thunderstorm',
      desc: 'Thunderstorm',
      args: [],
    );
  }

  /// `Drizzle`
  String get drizzle {
    return Intl.message(
      'Drizzle',
      name: 'drizzle',
      desc: 'Drizzle',
      args: [],
    );
  }

  /// `Rain`
  String get rain {
    return Intl.message(
      'Rain',
      name: 'rain',
      desc: 'Rain',
      args: [],
    );
  }

  /// `Snow`
  String get snow {
    return Intl.message(
      'Snow',
      name: 'snow',
      desc: 'Snow',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: 'Clear',
      args: [],
    );
  }

  /// `Clouds`
  String get clouds {
    return Intl.message(
      'Clouds',
      name: 'clouds',
      desc: 'Clouds',
      args: [],
    );
  }

  /// `Mist`
  String get mist {
    return Intl.message(
      'Mist',
      name: 'mist',
      desc: 'Mist',
      args: [],
    );
  }

  /// `Fog`
  String get fog {
    return Intl.message(
      'Fog',
      name: 'fog',
      desc: 'Fog',
      args: [],
    );
  }

  /// `Smoke`
  String get smoke {
    return Intl.message(
      'Smoke',
      name: 'smoke',
      desc: 'Smoke',
      args: [],
    );
  }

  /// `Haze`
  String get haze {
    return Intl.message(
      'Haze',
      name: 'haze',
      desc: 'Haze',
      args: [],
    );
  }

  /// `Dust`
  String get dust {
    return Intl.message(
      'Dust',
      name: 'dust',
      desc: 'Dust',
      args: [],
    );
  }

  /// `Sand`
  String get sand {
    return Intl.message(
      'Sand',
      name: 'sand',
      desc: 'Sand',
      args: [],
    );
  }

  /// `Ash`
  String get ash {
    return Intl.message(
      'Ash',
      name: 'ash',
      desc: 'Ash',
      args: [],
    );
  }

  /// `Squall`
  String get squall {
    return Intl.message(
      'Squall',
      name: 'squall',
      desc: 'Squall',
      args: [],
    );
  }

  /// `Tornado`
  String get tornado {
    return Intl.message(
      'Tornado',
      name: 'tornado',
      desc: 'Tornado',
      args: [],
    );
  }

  /// `Thunderstorm with Light Rain`
  String get thunderstormWithLightRain {
    return Intl.message(
      'Thunderstorm with Light Rain',
      name: 'thunderstormWithLightRain',
      desc: '',
      args: [],
    );
  }

  /// `Thunderstorm with Rain`
  String get thunderstormWithRain {
    return Intl.message(
      'Thunderstorm with Rain',
      name: 'thunderstormWithRain',
      desc: '',
      args: [],
    );
  }

  /// `Thunderstorm with Heavy Rain`
  String get thunderstormWithHeavyRain {
    return Intl.message(
      'Thunderstorm with Heavy Rain',
      name: 'thunderstormWithHeavyRain',
      desc: '',
      args: [],
    );
  }

  /// `Light Thunderstorm`
  String get lightThunderstorm {
    return Intl.message(
      'Light Thunderstorm',
      name: 'lightThunderstorm',
      desc: '',
      args: [],
    );
  }

  /// `Heavy Thunderstorm`
  String get heavyThunderstorm {
    return Intl.message(
      'Heavy Thunderstorm',
      name: 'heavyThunderstorm',
      desc: '',
      args: [],
    );
  }

  /// `Ragged Thunderstorm`
  String get raggedThunderstorm {
    return Intl.message(
      'Ragged Thunderstorm',
      name: 'raggedThunderstorm',
      desc: '',
      args: [],
    );
  }

  /// `Thunderstorm with Light Drizzle`
  String get thunderstormWithLightDrizzle {
    return Intl.message(
      'Thunderstorm with Light Drizzle',
      name: 'thunderstormWithLightDrizzle',
      desc: '',
      args: [],
    );
  }

  /// `Thunderstorm with Drizzle`
  String get thunderstormWithDrizzle {
    return Intl.message(
      'Thunderstorm with Drizzle',
      name: 'thunderstormWithDrizzle',
      desc: '',
      args: [],
    );
  }

  /// `Thunderstorm with Heavy Drizzle`
  String get thunderstormWithHeavyDrizzle {
    return Intl.message(
      'Thunderstorm with Heavy Drizzle',
      name: 'thunderstormWithHeavyDrizzle',
      desc: '',
      args: [],
    );
  }

  /// `Light Intensity Drizzle`
  String get lightIntensityDrizzle {
    return Intl.message(
      'Light Intensity Drizzle',
      name: 'lightIntensityDrizzle',
      desc: '',
      args: [],
    );
  }

  /// `Heavy Intensity Drizzle`
  String get heavyIntensityDrizzle {
    return Intl.message(
      'Heavy Intensity Drizzle',
      name: 'heavyIntensityDrizzle',
      desc: '',
      args: [],
    );
  }

  /// `Light Intensity Drizzle Rain`
  String get lightIntensityDrizzleRain {
    return Intl.message(
      'Light Intensity Drizzle Rain',
      name: 'lightIntensityDrizzleRain',
      desc: '',
      args: [],
    );
  }

  /// `Drizzle Rain`
  String get drizzleRain {
    return Intl.message(
      'Drizzle Rain',
      name: 'drizzleRain',
      desc: '',
      args: [],
    );
  }

  /// `Heavy Intensity Drizzle Rain`
  String get heavyIntensityDrizzleRain {
    return Intl.message(
      'Heavy Intensity Drizzle Rain',
      name: 'heavyIntensityDrizzleRain',
      desc: '',
      args: [],
    );
  }

  /// `Shower Rain and Drizzle`
  String get showerRainAndDrizzle {
    return Intl.message(
      'Shower Rain and Drizzle',
      name: 'showerRainAndDrizzle',
      desc: '',
      args: [],
    );
  }

  /// `Heavy Shower Rain and Drizzle`
  String get heavyShowerRainAndDrizzle {
    return Intl.message(
      'Heavy Shower Rain and Drizzle',
      name: 'heavyShowerRainAndDrizzle',
      desc: '',
      args: [],
    );
  }

  /// `Shower Drizzle`
  String get showerDrizzle {
    return Intl.message(
      'Shower Drizzle',
      name: 'showerDrizzle',
      desc: '',
      args: [],
    );
  }

  /// `Light Rain`
  String get lightRain {
    return Intl.message(
      'Light Rain',
      name: 'lightRain',
      desc: '',
      args: [],
    );
  }

  /// `Moderate Rain`
  String get moderateRain {
    return Intl.message(
      'Moderate Rain',
      name: 'moderateRain',
      desc: '',
      args: [],
    );
  }

  /// `Heavy Intensity Rain`
  String get heavyIntensityRain {
    return Intl.message(
      'Heavy Intensity Rain',
      name: 'heavyIntensityRain',
      desc: '',
      args: [],
    );
  }

  /// `Very Heavy Rain`
  String get veryHeavyRain {
    return Intl.message(
      'Very Heavy Rain',
      name: 'veryHeavyRain',
      desc: '',
      args: [],
    );
  }

  /// `Extreme Rain`
  String get extremeRain {
    return Intl.message(
      'Extreme Rain',
      name: 'extremeRain',
      desc: '',
      args: [],
    );
  }

  /// `Freezing Rain`
  String get freezingRain {
    return Intl.message(
      'Freezing Rain',
      name: 'freezingRain',
      desc: '',
      args: [],
    );
  }

  /// `Light Intensity Shower Rain`
  String get lightIntensityShowerRain {
    return Intl.message(
      'Light Intensity Shower Rain',
      name: 'lightIntensityShowerRain',
      desc: '',
      args: [],
    );
  }

  /// `Shower Rain`
  String get showerRain {
    return Intl.message(
      'Shower Rain',
      name: 'showerRain',
      desc: '',
      args: [],
    );
  }

  /// `Heavy Intensity Shower Rain`
  String get heavyIntensityShowerRain {
    return Intl.message(
      'Heavy Intensity Shower Rain',
      name: 'heavyIntensityShowerRain',
      desc: '',
      args: [],
    );
  }

  /// `Ragged Shower Rain`
  String get raggedShowerRain {
    return Intl.message(
      'Ragged Shower Rain',
      name: 'raggedShowerRain',
      desc: '',
      args: [],
    );
  }

  /// `Light Snow`
  String get lightSnow {
    return Intl.message(
      'Light Snow',
      name: 'lightSnow',
      desc: '',
      args: [],
    );
  }

  /// `Heavy Snow`
  String get heavySnow {
    return Intl.message(
      'Heavy Snow',
      name: 'heavySnow',
      desc: '',
      args: [],
    );
  }

  /// `Sleet`
  String get sleet {
    return Intl.message(
      'Sleet',
      name: 'sleet',
      desc: '',
      args: [],
    );
  }

  /// `Light Shower Sleet`
  String get lightShowerSleet {
    return Intl.message(
      'Light Shower Sleet',
      name: 'lightShowerSleet',
      desc: '',
      args: [],
    );
  }

  /// `Shower Sleet`
  String get showerSleet {
    return Intl.message(
      'Shower Sleet',
      name: 'showerSleet',
      desc: '',
      args: [],
    );
  }

  /// `Light Rain and Snow`
  String get lightRainAndSnow {
    return Intl.message(
      'Light Rain and Snow',
      name: 'lightRainAndSnow',
      desc: '',
      args: [],
    );
  }

  /// `Rain and Snow`
  String get rainAndSnow {
    return Intl.message(
      'Rain and Snow',
      name: 'rainAndSnow',
      desc: '',
      args: [],
    );
  }

  /// `Light Shower Snow`
  String get lightShowerSnow {
    return Intl.message(
      'Light Shower Snow',
      name: 'lightShowerSnow',
      desc: '',
      args: [],
    );
  }

  /// `Shower Snow`
  String get showerSnow {
    return Intl.message(
      'Shower Snow',
      name: 'showerSnow',
      desc: '',
      args: [],
    );
  }

  /// `Heavy Shower Snow`
  String get heavyShowerSnow {
    return Intl.message(
      'Heavy Shower Snow',
      name: 'heavyShowerSnow',
      desc: '',
      args: [],
    );
  }

  /// `Sand/Dust Whirls`
  String get sandDustWhirls {
    return Intl.message(
      'Sand/Dust Whirls',
      name: 'sandDustWhirls',
      desc: '',
      args: [],
    );
  }

  /// `Volcanic Ash`
  String get volcanicAsh {
    return Intl.message(
      'Volcanic Ash',
      name: 'volcanicAsh',
      desc: '',
      args: [],
    );
  }

  /// `Squalls`
  String get squalls {
    return Intl.message(
      'Squalls',
      name: 'squalls',
      desc: '',
      args: [],
    );
  }

  /// `Clear Sky`
  String get clearSky {
    return Intl.message(
      'Clear Sky',
      name: 'clearSky',
      desc: '',
      args: [],
    );
  }

  /// `Few Clouds`
  String get fewClouds {
    return Intl.message(
      'Few Clouds',
      name: 'fewClouds',
      desc: '',
      args: [],
    );
  }

  /// `Scattered Clouds`
  String get scatteredClouds {
    return Intl.message(
      'Scattered Clouds',
      name: 'scatteredClouds',
      desc: '',
      args: [],
    );
  }

  /// `Broken Clouds`
  String get brokenClouds {
    return Intl.message(
      'Broken Clouds',
      name: 'brokenClouds',
      desc: '',
      args: [],
    );
  }

  /// `Overcast Clouds`
  String get overcastClouds {
    return Intl.message(
      'Overcast Clouds',
      name: 'overcastClouds',
      desc: '',
      args: [],
    );
  }

  /// `Morning Temp`
  String get morningTemp {
    return Intl.message(
      'Morning Temp',
      name: 'morningTemp',
      desc: 'Morning Temperature',
      args: [],
    );
  }

  /// `Day Temp`
  String get dayTemp {
    return Intl.message(
      'Day Temp',
      name: 'dayTemp',
      desc: 'Day Temperature',
      args: [],
    );
  }

  /// `Evening Temp`
  String get eveningTemp {
    return Intl.message(
      'Evening Temp',
      name: 'eveningTemp',
      desc: 'Evening Temperature',
      args: [],
    );
  }

  /// `Night Temp`
  String get nightTemp {
    return Intl.message(
      'Night Temp',
      name: 'nightTemp',
      desc: 'Night Temperature',
      args: [],
    );
  }

  /// `detail`
  String get detail {
    return Intl.message(
      'detail',
      name: 'detail',
      desc: 'Detail',
      args: [],
    );
  }

  /// `Next Week`
  String get nextWeek {
    return Intl.message(
      'Next Week',
      name: 'nextWeek',
      desc: 'Next Week',
      args: [],
    );
  }

  /// `Weather Condition`
  String get weatherCondition {
    return Intl.message(
      'Weather Condition',
      name: 'weatherCondition',
      desc: 'Weather Condition',
      args: [],
    );
  }

  /// `Request error, please check your internet connection`
  String get requestError {
    return Intl.message(
      'Request error, please check your internet connection',
      name: 'requestError',
      desc: 'Request error message',
      args: [],
    );
  }

  /// `Location permissions are permanently denied, Please enable manually from app settings and restart the app`
  String get locationPermissionsDenied {
    return Intl.message(
      'Location permissions are permanently denied, Please enable manually from app settings and restart the app',
      name: 'locationPermissionsDenied',
      desc:
          'Message indicating that location permissions are permanently denied',
      args: [],
    );
  }

  /// `Location permission not granted, please check your location permission`
  String get locationPermissionNotGranted {
    return Intl.message(
      'Location permission not granted, please check your location permission',
      name: 'locationPermissionNotGranted',
      desc: 'Message indicating that location permission is not granted',
      args: [],
    );
  }

  /// `Now`
  String get now {
    return Intl.message(
      'Now',
      name: 'now',
      desc: 'Now',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: 'The word \'Search\'',
      args: [],
    );
  }

  /// `Permission denied`
  String get permissionDenied {
    return Intl.message(
      'Permission denied',
      name: 'permissionDenied',
      desc: 'The message shown when permission is denied',
      args: [],
    );
  }

  /// `Location service disabled`
  String get locationServiceDisabled {
    return Intl.message(
      'Location service disabled',
      name: 'locationServiceDisabled',
      desc: 'The message shown when location service is disabled',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
