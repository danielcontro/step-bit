import 'package:intl/intl.dart';

import 'heart_rate_zones.dart';

class Exercise {
    final String activityName;
    final int averageHeartRate;
    final int calories;
    final double? distance;
    final String? distanceUnit;
    final double duration;
    final double activeDuration;
    final int? steps;
    final String logType;
    final List<HeartRateZones> heartRateZones;
    final double? speed;
    final double? vO2Max;
    final double elevationGain;
    final DateTime time;

  const Exercise({required  this.activityName, required  this.averageHeartRate, required this.calories, required this.distance, required this.distanceUnit, required this.duration, required this.activeDuration, required this.steps, required this.logType, required this.heartRateZones, required this.speed, required this.vO2Max, required this.elevationGain, required this.time});

  factory Exercise.fromJson(String date, Map<String, dynamic> json) {
    return Exercise(
        activityName: json["activityName"],
        averageHeartRate: json["averageHeartRate"],
        calories: json["calories"],
        distance: double.tryParse(json["distance"].toString()),
        distanceUnit: json["distanceUnit"],
        duration: json["duration"] == 0
            ? 0.0
            : double.parse(json["duration"].toString()),
        activeDuration: json["activeDuration"] == 0
            ? 0.0
            : double.parse(json["activeDuration"].toString()),
        steps: json["steps"],
        logType: json["logType"],
        heartRateZones: json["heartRateZones"] != null
            ? json["heartRateZones"].map<HeartRateZones>((json) => HeartRateZones.fromJson(json)).toList()
            : List.empty(),
        speed: double.tryParse(json["speed"].toString()),
        vO2Max: double.tryParse(["VO2Max"].toString()),
        elevationGain: double.parse(json["elevationGain"].toString()),
        time: DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'));
  }

  @override
  String toString() {
    String s = heartRateZones.toString();
    return 'Exercise(activityName: $activityName, value: $averageHeartRate, calories: $calories, distance: $distance, distanceUnit: $distanceUnit, duration: $duration, activeDuration: $activeDuration, steps: $steps, logType: $logType, heartRateZones: $s, speed: $speed, VO2Max: $vO2Max, elevationGain: $elevationGain, time: $time )';
  }
}