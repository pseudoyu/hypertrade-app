import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hyper_app/generated/l10n.dart';
import 'package:hyper_app/provider/auth_provider.dart';
import 'package:hyper_app/provider/collection_provider.dart';
import 'package:hyper_app/provider/onboard_provider.dart';
import 'package:hyper_app/provider/vclist_provider.dart';
import 'package:hyper_app/provider/hyper_price_provider.dart';
import 'package:hyper_app/provider/hypertrade_provider.dart';
import 'package:hyper_app/provider/wallet_provider.dart';
import 'package:hyper_app/provider/strategy_provider.dart';
import 'package:hyper_app/screens/app_router.dart';
// import 'package:hyper_app/screens/routes.dart';
import 'package:provider/provider.dart';
import 'package:hyper_app/theme/text_style.dart';

import './provider/language_provider.dart';

Future<void> main() async {
  // Load environment variables before running the app
  await dotenv.load(fileName: '.env');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => VcInfoProvider()),
        ChangeNotifierProvider(create: (context) => AppLanguage()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => OnboardProvider()),
        ChangeNotifierProvider(create: (context) => CollectionProvider()),
        ChangeNotifierProvider(create: (context) => HyperPriceProvider()),
        ChangeNotifierProvider(create: (context) => HyperTradeProvider()),
        ChangeNotifierProvider(create: (context) => StrategyProvider()),
        ChangeNotifierProvider(create: (context) => WalletProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => VcInfoProvider()),
//         ChangeNotifierProvider(create: (context) => AppLanguage()),
//         ChangeNotifierProvider(create: (context) => AuthProvider()),
//         ChangeNotifierProvider(create: (context) => OnboardProvider()),
//         ChangeNotifierProvider(create: (context) => CollectionProvider()),
//         ChangeNotifierProvider(create: (context) => HyperPriceProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppLanguage>(
      builder: (context, appLanguage, child) {
        return MaterialApp.router(
          // routerConfig: router,
          routerConfig: AppRouter().router,
          title: 'hyper_pro',
          locale: appLanguage.appLocale, // 设置默认语言
          onGenerateTitle: (context) {
            return S.of(context).appTitle;
          },
          supportedLocales: const [
            Locale('en', 'US'), // 美国英语
            Locale('zh', 'CN'), // 中文简体
          ],
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFFFCC00),
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 2,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            scaffoldBackgroundColor: Colors.white,
            primaryColor: Colors.yellow,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Colors.yellow,
              onPrimary: Colors.blue,
              secondary: Colors.blue,
            ),
            fontFamily: 'Open Sans',
            fontFamilyFallback: fontFamilyFallbackList,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                color: Colors.black87,
              ),
              bodyMedium: TextStyle(
                color: Colors.black54,
              ),
              labelLarge: TextStyle(
                color: Colors.blue,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFCC00),
                foregroundColor: Colors.black87,
                textStyle: const TextStyle(
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
