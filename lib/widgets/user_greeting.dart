import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepbit/database/entities/person.dart';
import 'package:stepbit/repositories/database_repository.dart';

import '../utils/app_colors.dart';

class UserGreeting extends StatelessWidget {
  final String name;

  const UserGreeting({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseRepository>(builder: (context, dbr, child) {
      //The logic is to query the DB for the entire list of Meal using dbr.findAllMeals()
      //and then populate the ListView accordingly.
      //We need to use a FutureBuilder since the result of dbr.findAllMeals() is a Future.
      return FutureBuilder(
        future: dbr.database.personDao.findPersonById(1),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data as Person;
            //If the Meal table is empty, show a simple Text, otherwise show the list of meals using a ListView.
            return Text(
              "Hello ${data.name}!",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: AppColors.primaryColor),
            );
          } //if
          else {
            return const Text('');
          } //else
        }, //FutureBuilder builder
      );
    });
  }
}
