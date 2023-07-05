import 'package:easy_settings/easy_settings.dart';
import 'package:flutter/material.dart';

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
        ])
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
