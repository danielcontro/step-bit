import 'package:intl/intl.dart';

class HeartRate {
  final DateTime time;
  final int value;

  const HeartRate({required this.time, required this.value});

  factory HeartRate.fromJson(String date, Map<String, dynamic> json) {
    return HeartRate(
        time: DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
        value: json["value"]);
  }

  @override
  String toString() {
    return 'HeartRate(time: $time, value: $value)';
  }
}
