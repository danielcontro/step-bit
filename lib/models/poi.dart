/*
tourism = [artwork, attraction, viewpoint, museum, gallery, ]
building = [church, university, chapel, ]
historic = [building, ]
amenity = [place_of_worship, restaurant, fast_food, cafe, bar, pub, food_court, ice_cream, marketplace]
*/
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class POI {
  final LatLng position;
  final double distanceInKm;
  final Map<String, dynamic> tags;

  const POI({
    required this.position,
    required this.tags,
    required this.distanceInKm,
  });

  factory POI.fromJson(Map<String, dynamic> json, LatLng myPosition) {
    return POI(
      position: LatLng(json['lat'], json['lon']),
      tags: json['tags'],
      distanceInKm: getDistanceInKm(
          json['lat'], json['lon'], myPosition.latitude, myPosition.longitude),
    );
  }

  static double getDistanceInKm(
      double lat1, double lon1, double lat2, double lon2) {
    // return distance in km
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    final distance = 12742 * asin(sqrt(a));
    return double.parse(distance.toStringAsFixed(3));
  }

  String getName() => tags['name'];

  String? getCity() {
    if (tags.keys.contains('addr:city')) {
      return tags['addr:city'];
    } else {
      return null;
    }
  }

  String getStreet() => tags['addr:street'];

  String getWebsite() => tags['website'];

  String getType() {
    if (tags.keys.contains('tourism')) {
      return tags['tourism'];
    } else if (tags.keys.contains('building')) {
      return tags['building'];
    } else if (tags.keys.contains('historic')) {
      return tags['historic'];
    } else if (tags.keys.contains('amenity')) {
      return tags['amenity'];
    } else {
      return 'undefined';
    }
  }

  String getDistanceKmOrMeters() {
    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).round()} m';
    }
    return '$distanceInKm km';
  }

  @override
  String toString() {
    var tagsFormatted = tags.entries
        .fold('', (previousValue, element) => '$previousValue, $element');
    return 'POI(position: $position, tags: $tagsFormatted)';
  }
}
