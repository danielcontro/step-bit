import 'dart:math';

import 'package:activity_ring/activity_ring.dart';
import 'package:easy_settings/easy_settings.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

import '../screens/settings.dart';

class StepRing extends StatelessWidget {
  final int steps;

  const StepRing({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider<SettingsPropertyChangedNotifier, String>(
      value: settingsPropertyChangedNotifier,
      child: PropertyChangeConsumer<SettingsPropertyChangedNotifier, String>(
        properties: const [dailyStepsGoalKey],
        builder: (p0, p1, p2) {
          var rawValue = getSettingsPropertyValue<int>(dailyStepsGoalKey);
          final stepsGoal = max(1000, rawValue.abs());
          final progress = steps / stepsGoal * 100;
          return Ring(
            percent: min(299, steps / stepsGoal * 100),
            animate: true,
            color: RingColorScheme(
              ringGradient: [
                Colors.red,
                Colors.yellow,
                Colors.lime,
                Colors.green,
              ],
            ),
            radius: MediaQuery.of(context).size.width * 0.072,
            width: MediaQuery.of(context).size.width * 0.01,
            child: Text(
              '${progress.round()}%',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.035),
            ),
          );
        },
      ),
    );
  }
}
