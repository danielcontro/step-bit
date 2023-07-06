import 'package:easy_settings/easy_settings.dart';
import 'package:flutter/material.dart';
import 'package:stepbit/screens/login.dart';
import 'package:stepbit/utils/token_manager.dart';

const String dailyStepsGoalKey = "dailyStepsGoal";

List<SettingsCategory> settingsCategories = [
  SettingsCategory(
      title: "Main category",
      iconData: Icons.settings,
      settingsSections: [
        SettingsSection(settingsElements: [
          IntSettingsProperty(
              key: dailyStepsGoalKey,
              title: "Set your daily steps goal",
              defaultValue: 8000,
              iconData: Icons.assist_walker),
          ButtonSettingsElement(
              title: "Quick reset settings",
              iconData: Icons.restore,
              onClick: (BuildContext context) => resetSettings()),
          ButtonSettingsElement(
              title: "Logout",
              iconData: Icons.logout,
              onClick: (BuildContext context) {
                TokenManager.clearTokens();
                final nav = Navigator.of(context);
                nav.pop();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Login()));
              }),
        ]),
      ])
];

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: const EasySettingsWidget());
  }
}
