import 'package:flutter/material.dart';

import '../models/exercise.dart';

class ActivityCard extends StatelessWidget {
  final Exercise exercise;

  const ActivityCard({super.key, required this.exercise});

  Icon getActivityIcon() {
    if (exercise.activityName.toLowerCase() == "corsa") {
      return const Icon(Icons.directions_run);
    } else if (exercise.activityName.toLowerCase() == "camminata") {
      return const Icon(Icons.directions_walk);
    } else if (exercise.activityName.toLowerCase() == "bici") {
      return const Icon(Icons.pedal_bike);
    } else {
      return const Icon(Icons.question_mark);
    }
  }

  @override
  Widget build(BuildContext context) {
    final minute = exercise.duration / 60;

    return ListTile(
      leading: getActivityIcon(),
      title: Text('${exercise.activityName} - ${exercise.convertToLocal()}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.watch_later, size: 15),
            Text(' ${minute.round().toString()} minutes'),
          ]),
          Row(children: [
            const Icon(Icons.favorite, size: 15),
            Text(' ${exercise.averageHeartRate} bpm'),
          ]),
          if (exercise.distance != null && exercise.distanceUnit != null)
            Row(children: [
              const Icon(Icons.timeline, size: 15),
              Text(
                  ' ${exercise.distance!.roundToDouble()} ${exercise.distanceUnit}'),
            ]),
        ],
      ),
    );
  }
}
