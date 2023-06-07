import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:stepbit/main.dart';
import 'package:stepbit/models/exercise.dart';
import 'package:stepbit/utils/app_colors.dart';
import 'package:stepbit/widgets/activity_card.dart';
import 'package:stepbit/widgets/user_greeting.dart';
import 'package:stepbit/widgets/yesterday_steps.dart';

import '../utils/api_client.dart';

class StartActivity extends StatelessWidget {
  const StartActivity({Key? key}) : super(key: key);

  Widget userGreeting(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserGreeting(name: name),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: YesterdaySteps(),
        ),
      ],
    ).animate().fade(duration: 500.ms).slideY(curve: Curves.bounceOut);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(5, 20, 0, 0),
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.boxDecorationColor.withOpacity(0.7),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.3),
                spreadRadius: 10,
                blurRadius: 10,
                offset: const Offset(10, 0), // changes position of shadow
              ),
            ],
          ),
          child: userGreeting("Luca"),
        ),
        const SizedBox(
          height: 50,
        ),
        FutureBuilder(
          future: ApiClient.getExercisesStartEnd(
              DateTime.now().subtract(const Duration(days: 7)),
              DateTime.now().subtract(const Duration(days: 1))),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final exercises = snapshot.data as List<Exercise>;
              return Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: exercises.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return ActivityCard(
                      exercise: exercises[index],
                    );
                  },
                ),
              );
            } else {
              return const Loading();
            }
          },
        ),
        /*ElevatedButton(
            onPressed: () async {
              final result = await ApiClient.getExercisesStartEnd(
                  DateTime(2023, 5, 21), DateTime(2023, 05, 28));
              print(result);
              result?.forEach((element) => debugPrint(element.toString()));
              final message =
                  result == null ? 'Request failed' : 'Request successful';
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(message)));
              }
            },
            child: const Text('Get the Exercise data')),*/
      ],
    );
  }
}
