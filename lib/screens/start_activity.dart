import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:stepbit/models/exercise.dart';
import 'package:stepbit/utils/app_colors.dart';
import 'package:stepbit/widgets/activity_card.dart';
import 'package:stepbit/widgets/quantity_input.dart';
import 'package:stepbit/widgets/user_greeting.dart';
import 'package:stepbit/widgets/yesterday_steps.dart';

import '../utils/api_client.dart';
import '../widgets/loading.dart';

class StartActivity extends StatelessWidget {
  final PageController pageController;
  final Function(int) mapCallback;

  StartActivity(
      {Key? key, required this.pageController, required this.mapCallback})
      : super(key: key);

  int selectedValue = 1;

  _changeprice(int num) {
    selectedValue = num;
  }

  Widget stepsTopBar() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserGreeting(name: "Luca"),
          YesterdaySteps(),
        ],
      ),
    ).animate().fade(duration: 500.ms).slideY(curve: Curves.bounceOut);
  }

  Widget lastActivities() {
    return FutureBuilder(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(5, 20, 5, 0),
          width: double.infinity,
          height: 85,
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
          child: stepsTopBar(),
        ),
        const SizedBox(
          height: 50,
        ),
        Center(
          child: QuantityInput(
            initialValue: selectedValue,
            max: 20,
            min: 1,
            step: 1,
            onChanged: (value) {
              _changeprice(value);
            },
          ),
          /*ElevatedButton(
            // Bottone per iniziare una nuovo allenamento
            onPressed: () {
              mapCallback(Random().nextInt(10));
              pageController.animateToPage(2,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.bounceOut);
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              )),
            ),
            child: const Text(
              'START',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),*/
        ),
        const SizedBox(
          height: 50,
        ),
        const Text(
          "Your last activities",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        lastActivities()
      ],
    );
  }
}
