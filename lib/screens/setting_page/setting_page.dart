import 'package:flutter/material.dart';
import 'package:hyper_app/widgets/switch_language.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setting')),
      body: ListView(
        children: const [
          ListTile(
            title: LanguageSwitcher(),
          )
        ],
      ),
    );
  }
}
