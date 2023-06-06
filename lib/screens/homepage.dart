import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:stepbit/utils/api_client.dart';
import 'package:stepbit/utils/extension_methods.dart';

import '../models/steps.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget userGreeting(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Hello $name!",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            )),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: yesterdaySteps(),
        ),
      ],
    ).animate().fade(duration: 500.ms).slideX(curve: Curves.easeIn);
  }

  Widget yesterdaySteps() {
    return FutureBuilder(
        future: ApiClient.getSteps(
            DateTime.now().subtract(const Duration(days: 1))),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final steps = snapshot.data as List<Steps>;
            final dailySteps = steps.map((e) => e.value).sum();
            return AnimatedDigitWidget(
              value: dailySteps,
              textStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 17,
                color: Colors.grey,
              ),
              prefix: "You walked ",
              suffix: " steps yesterday",
            );
          } else {
            return const Text("");
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
              child: userGreeting("Luca")),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                final result =
                    await ApiClient.getExercises(DateTime(2023, 5, 25));
                result?.forEach((element) => debugPrint(element.toString()));
                final message =
                    result == null ? 'Request failed' : 'Request successful';
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(message)));
                }
              },
              child: const Text('Get the Exercise data')),
        ],
      ),
    );
  }
}
