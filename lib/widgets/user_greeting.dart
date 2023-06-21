import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepbit/database/entities/person.dart';
import 'package:stepbit/repositories/database_repository.dart';

import '../utils/app_colors.dart';

class UserGreeting extends StatelessWidget {
  const UserGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 30,
      color: AppColors.primaryColor,
    );
    return Consumer<DatabaseRepository>(builder: (context, dbr, child) {
      return FutureBuilder<Person?>(
        future: dbr.database.personDao.findPersonById(1),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final name = snapshot.data!.name;
            return Text("Hello $name!", style: textStyle);
          } else {
            return Text('Hello', style: textStyle);
          }
        },
      );
    });
  }
}
