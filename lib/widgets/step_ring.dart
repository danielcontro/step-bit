import 'package:activity_ring/activity_ring.dart';
import 'package:flutter/material.dart';

class StepRing extends StatelessWidget {
  final int steps;

  const StepRing({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    const stepsGoal = 8000;
    final progress = steps / stepsGoal * 100;
    return Ring(
      percent: progress,
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
        style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035),
      ),
    );
  }
}
