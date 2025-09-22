import 'package:flutter/material.dart';
import 'package:hyper_app/extensions/privy/features/authenticated/authenticated_screen.dart';
import 'package:hyper_app/screens/hyper_price_view.dart';
import 'package:hyper_app/provider/auth_provider.dart';
import 'package:hyper_app/provider/collection_provider.dart';
import 'package:hyper_app/provider/vclist_provider.dart';
import 'package:hyper_app/screens/wallet_page/wallet_page.dart';
import 'package:hyper_app/screens/strategy_page/strategy_page.dart';
import 'package:hyper_app/helper/haptic_utils.dart';
import 'package:hyper_app/widgets/inapp_web.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final int? initialIndex;
  const HomeScreen({super.key, this.initialIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FloatingSearchBarController fsc = FloatingSearchBarController();
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    requestVCListData();
    requestUserInfo();
    _controller =
        PersistentTabController(initialIndex: widget.initialIndex ?? 0);
  }

  Future<void> requestVCListData() async {
    await Provider.of<VcInfoProvider>(context, listen: false)
        .getVcInfos(limit: 10, offset: 0);
  }

  Future<void> requestCollectionVCListData() async {
    await Provider.of<CollectionProvider>(context, listen: false)
        .fetchLikeList();
  }

  Future<void> requestUserInfoData() async {
    await Provider.of<AuthProvider>(context, listen: false).fetchUserInfo();
  }

  Future<void> requestUserInfo() async {
    // AuthProvider authProvider =
    //     Provider.of<AuthProvider>(context, listen: false);
    // await authProvider.fetchUserInfo();
    // if (!mounted) return;
    // if (authProvider.userData == null) {
    //   context.goNamed('login');
    // } else if (!authProvider.userData!.isOnboarded) {
    //   context.goNamed('onboard');
    // } else {
    //   requestUserInfoData();
    //   requestCollectionVCListData();
    // }
  }

  List<Widget> _buildScreens() {
    return [
      // VCListPage(fsc: fsc),
      const WalletPage(),
      const StrategyPage(),
      const WebViewComponent(
        title: 'hyper_pro',
        initialUrl: "https://app.hyperliquid.xyz/trade", // 初始加载的网页
        hideElementsScript: '''
                  document.querySelectorAll('#root > div.sc-fEXmlR.ejmSgi > div:nth-child(2) > div').forEach(function(element) {
                    element.style.display = 'none';
                  });
                  var xpath = "//*[@id="root"]/div[4]/div[2]";
                  var element = document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;

                  if (element) {
                    element.style.display = 'none';
                  }
                ''',
      ),
      const HyperPriceView(),
      // const MyProfilePage(),
      const AuthenticatedScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      // _buildNavBarItem(icon: Icons.explore, title: "Explore"),
      _buildNavBarItem(icon: Icons.people, title: "Wallet"),
      _buildNavBarItem(icon: Icons.auto_graph, title: "Strategy"),
      _buildNavBarItem(icon: Icons.chat, title: "Trade"),
      _buildNavBarItem(icon: Icons.bar_chart, title: "Market"),
      _buildNavBarItem(icon: Icons.account_circle, title: "Profile"),
    ];
  }

  PersistentBottomNavBarItem _buildNavBarItem({
    required IconData icon,
    required String title,
  }) {
    return PersistentBottomNavBarItem(
      icon: Icon(icon),
      title: title,
      activeColorPrimary: const Color(0xFF00D2FF),
      inactiveColorPrimary: const Color(0xFF6B7280),
      iconSize: 26,
      contentPadding: 0,
      textStyle: const TextStyle(
        fontSize: 11,
        height: 0.1,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      navBarHeight: 70,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      onItemSelected: (index) {
        HapticUtils.lightTap();
      },
      navBarStyle: NavBarStyle.style6,
      decoration: NavBarDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        colorBehindNavBar: const Color(0xFF111827),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D2FF).withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF111827),
      padding: const EdgeInsets.only(top: 12, bottom: 8),
    );
  }
}
