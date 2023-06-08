import 'dart:io';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/poi.dart';

class OverpassApi {
  static const String _endpoint = "https://overpass-api.de/api/interpreter/";
  static final dio = Dio(BaseOptions(baseUrl: _endpoint));
  static const int _timeout = 10;

  static Future<List<POI>> query(
      Map<String, String> tags, LatLng position, double distance) {
    return dio.post(
      '',
      data: '''
        [out:json][timeout:$_timeout];
        node${tags.entries.fold('', (previousValue, element) => '$previousValue[${element.key}=${element.value}]')}(around:$distance,${position.latitude}, ${position.longitude});
       out center;
    ''',
    ).then((value) {
      if (value.statusCode != HttpStatus.ok) {
        Future.error("Error performing query");
      }
      final List data = value.data['elements'];
      return data.map((e) => POI.fromJson(e)).toList();
    });
  }
}
