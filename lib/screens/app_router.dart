import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_app/extensions/privy/features/authenticated/authenticated_screen.dart';
import 'package:hyper_app/extensions/privy/features/email_authentication/email_authentication_screen.dart';
import 'package:hyper_app/extensions/privy/features/privy_login/privy_login_screen.dart';
import 'package:hyper_app/extensions/privy/features/wallet/eth_wallet_screen.dart';
import 'package:hyper_app/screens/chat_page/chat_page.dart';
import 'package:hyper_app/screens/common_page/empty_page/empty_page.dart';
import 'package:hyper_app/screens/common_page/error_page/request_error.dart';
import 'package:hyper_app/screens/common_page/login_page/login_page.dart';
import 'package:hyper_app/screens/common_page/onboarding_page/onboarding_page.dart';
import 'package:hyper_app/screens/home_screen.dart';
import 'package:hyper_app/screens/hyper_price_view.dart';
import 'package:hyper_app/screens/profile_page/profile_page.dart';
import 'package:hyper_app/screens/profile_page/vc_collection_page/collection_vc_list_page.dart';
import 'package:hyper_app/screens/setting_page/setting_page.dart';
import 'package:hyper_app/widgets/inapp_web.dart';
import 'package:privy_flutter/privy_flutter.dart';

class AppRouter {
  // Private constructor to prevent direct instantiation
  AppRouter._();

  // Static instance for singleton access
  static final AppRouter _instance = AppRouter._();

  // Factory constructor to return the singleton instance
  factory AppRouter() => _instance;

  // Route name constants
  static const String homeRoute = 'homedemo';
  static const String home = 'home';
  static const String authenticatedRoute = 'authenticated';
  static const String emailAuthRoute = 'email-auth';
  static const String ethWalletRoute = 'eth-wallet';

  // Route path constants
  static const String homePath = '/';
  static const String privyLoginPath = '/privy_login';
  static const String emailAuthPath = '/email-auth';
  static const String authenticatedPath = '/profile';
  static const String ethWalletPath = '/eth-wallet';

  // GoRouter configuration
  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: privyLoginPath,
    routes: [
      // Main routes
      GoRoute(
        path: privyLoginPath,
        name: homeRoute,
        builder: (context, state) => const PrivyLoginScreen(),
      ),
      GoRoute(
        path: authenticatedPath,
        name: authenticatedRoute,
        builder: (context, state) {
          // final user = state.extra as PrivyUser?;
          return AuthenticatedScreen();
        },
      ),
      GoRoute(
        path: emailAuthPath,
        name: emailAuthRoute,
        builder: (context, state) => const EmailAuthenticationScreen(),
      ),
      GoRoute(
        path: ethWalletPath,
        name: ethWalletRoute,
        builder: (context, state) {
          final wallet = state.extra as EmbeddedEthereumWallet;
          return EthWalletScreen(ethereumWallet: wallet);
        },
      ),
      GoRoute(
        path: homePath,
        name: home,
        builder: (context, state) {
          final indexStr = state.uri.queryParameters['index'];
          int? index;
          if (indexStr != null) {
            index = int.tryParse(indexStr) ?? 0;
          }
          return HomeScreen(initialIndex: index);
        },
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const ChatListPage(),
      ),
      GoRoute(
        path: '/empty',
        builder: (context, state) => const EmptyPage(),
      ),
      GoRoute(
        path: '/error',
        builder: (context, state) => const RequestErrorDisplay(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const MyProfilePage(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/onboard',
        name: 'onboard',
        builder: (context, state) => const StartupFormPage(),
      ),
      GoRoute(
        path: '/collectionvc',
        name: 'collectionvc',
        builder: (context, state) => const CollectionVCListPage(),
      ),
      GoRoute(
        path: '/hyperprice',
        name: 'hyperprice',
        builder: (context, state) => const HyperPriceView(),
      ),
      GoRoute(
        path: '/privacy',
        name: 'privacy',
        builder: (context, state) => const WebViewComponent(
          title: "Privacy & Security",
          initialUrl:
              "https://www.yuque.com/cityheroes/project/wh61hk2u8zdqbfwk?view=doc_embed&from=yuyan&title=1&outline=1",
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(child: Text('No route defined for ${state.uri.path}')),
    ),
  );
}
