import 'package:flutter/material.dart';
import 'package:hyper_app/generated/l10n.dart';
import 'package:hyper_app/widgets/switch_language.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
            width: double.infinity,
            height: 380.0,
            child: DrawerHeader(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg/drawer_bg.webp'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  'will you really love me? \n I think I will',
                  style: TextStyle(
                    color: Colors.black12, // 根据需要设置文字颜色
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ),
          const ListTile(
            title: LanguageSwitcher(),
          ),
          ListTile(
            title: Text(
              S.of(context).aboutus,
              style: const TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              // Handle drawer item click
            },
          ),
          ListTile(
            title: Text(
              S.of(context).sometalk,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            onTap: () {
              // Handle drawer item click
            },
          ),
        ],
      ),
    );
  }
}
