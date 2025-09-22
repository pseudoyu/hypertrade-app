// import 'package:go_router/go_router.dart';
// import 'package:hyper_app/screens/chat_page/chat_page.dart';
// import 'package:hyper_app/screens/common_page/empty_page/empty_page.dart';
// import 'package:hyper_app/screens/common_page/error_page/request_error.dart';
// import 'package:hyper_app/screens/common_page/login_page/login_page.dart';
// import 'package:hyper_app/screens/common_page/onboarding_page/onboarding_page.dart';
// import 'package:hyper_app/screens/home_screen.dart';
// import 'package:hyper_app/screens/profile_page/profile_page.dart';
// import 'package:hyper_app/screens/profile_page/vc_collection_page/collection_vc_list_page.dart';
// import 'package:hyper_app/screens/hyper_price_view.dart';
// import 'package:hyper_app/screens/setting_page/setting_page.dart';
// import 'package:hyper_app/widgets/inapp_web.dart';

// final GoRouter router = GoRouter(
//   routes: [

//     GoRoute(
//       path: '/',
//       name: 'home',
//       builder: (context, state) {
//         final indexStr = state.uri.queryParameters['index'];
//         int? index;
//         if (indexStr != null) {
//           index = int.tryParse(indexStr) ?? 0;
//         }
//         return HomeScreen(initialIndex: index);
//       },
//     ),
//     GoRoute(
//       path: '/chat',
//       builder: (context, state) => const ChatListPage(),
//     ),
//     GoRoute(
//       path: '/empty',
//       builder: (context, state) => const EmptyPage(),
//     ),
//     GoRoute(
//       path: '/error',
//       builder: (context, state) => const RequestErrorDisplay(),
//     ),
//     GoRoute(
//       path: '/profile',
//       builder: (context, state) => const MyProfilePage(),
//     ),
//     GoRoute(
//       path: '/settings',
//       name: 'settings',
//       builder: (context, state) => const SettingPage(),
//     ),
//     GoRoute(
//       path: '/login',
//       name: 'login',
//       builder: (context, state) => const LoginPage(),
//     ),
//     GoRoute(
//       path: '/onboard',
//       name: 'onboard',
//       builder: (context, state) => const StartupFormPage(),
//     ),
//     GoRoute(
//       path: '/collectionvc',
//       name: 'collectionvc',
//       builder: (context, state) => const CollectionVCListPage(),
//     ),
//     GoRoute(
//       path: '/hyperprice',
//       name: 'hyperprice',
//       builder: (context, state) => const HyperPriceView(),
//     ),
//     GoRoute(
//       path: '/privacy',
//       name: 'privacy',
//       builder: (context, state) => const WebViewComponent(
//         title: "Privacy & Security",
//         initialUrl:
//             "https://www.yuque.com/cityheroes/project/wh61hk2u8zdqbfwk?view=doc_embed&from=yuyan&title=1&outline=1",
//       ),
//     ),
//   ],
//   // redirect: (context, state) {
//   //   // 如果路径为空或者其他非法路径，重定向到首页
//   //   if (state.path == '/') {
//   //     return null; // '/' 是首页，正常加载
//   //   }
//   //   return '/'; // 重定向到首页
//   // },
//   errorBuilder: (context, state) => const LoginPage(), // 自定义错误页面
// );
