class HeartRateZones {
  final String name;
  final int min;
  final int max;
  final int minutes;
  final double caloriesOut;

  const HeartRateZones(
      {required this.name,
      required this.min,
      required this.max,
      required this.minutes,
      required this.caloriesOut});

  factory HeartRateZones.fromJson(Map<String, dynamic> json) {
    return HeartRateZones(
        name: json["name"],
        min: json["min"],
        max: json["max"],
        minutes: json["minutes"],
        caloriesOut: double.parse(json["caloriesOut"].toString()));
  }

  @override
  String toString() {
    return 'HeartRateZones(name: $name, min: $min, max: $max, minutes: $minutes, caloriesOut: $caloriesOut)';
  }
}
