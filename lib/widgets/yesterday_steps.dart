import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:stepbit/utils/extension_methods.dart';
import 'package:stepbit/widgets/step_ring.dart';

import '../models/steps.dart';
import '../utils/api_client.dart';
import '../utils/app_colors.dart';

class YesterdaySteps extends StatelessWidget {
  const YesterdaySteps({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ApiClient.getSteps(
            DateTime.now().subtract(const Duration(days: 1))),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final steps = snapshot.data as List<Steps>;
            final dailySteps = steps.map((e) => e.value).sum();
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AnimatedDigitWidget(
                  value: dailySteps,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 17,
                    color: AppColors.textColor,
                  ),
                  prefix: "You walked ",
                  suffix: " steps yesterday",
                ),
                const SizedBox(
                  width: 60,
                ),
                StepRing(steps: dailySteps)
              ],
            );
          } else {
            return const Text("");
          }
        });
  }
}
