import 'package:flutter/material.dart';

import '../models/exercise.dart';

class ActivityCard extends StatelessWidget {
  final Exercise exercise;

  const ActivityCard({super.key, required this.exercise});

  Icon getActivityIcon() {
    return switch (exercise.activityName.toLowerCase()) {
      "running" => const Icon(Icons.directions_run),
      "walking" => const Icon(Icons.directions_walk),
      "spinning" || "cycling" => const Icon(Icons.directions_bike),
      "sport" => const Icon(Icons.sports_handball),
      _ => const Icon(Icons.question_mark)
    };
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
