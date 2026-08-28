import 'package:flutter/material.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/settings/widget/setting_appearance.dart';
import 'package:qbpanel/settings/widget/setting_server.dart';

class SettingsPage extends StatefulWidget {

  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }

}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settingsTitle),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 24 + bottomSafe),
        children: [
          SettingServer(),
          SettingAppearance(),
        ],
      ),
    );
  }

}