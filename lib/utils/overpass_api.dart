import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/poi.dart';

class OverpassApi {
  static const String _baseUrl = "https://overpass-api.de/api/interpreter/";
  var dio = Dio();
  static const int _timeout = 10;

  OverpassApi() {
    dio.options = BaseOptions(baseUrl: _baseUrl);
    dio.interceptors.add(DioCacheInterceptor(
        options: CacheOptions(
            store: MemCacheStore(),
            policy: CachePolicy.request,
            hitCacheOnErrorExcept: [401, 403],
            maxStale: const Duration(days: 7),
            priority: CachePriority.normal,
            cipher: null,
            keyBuilder: CacheOptions.defaultCacheKeyBuilder,
            allowPostMethod: true)));
  }

  Future<List<POI>> query(
      List<(String, String)> tags, LatLng position, double distance) {
    final tagsFormatted = tags
        .map((e) =>
            'node[${e.$1}=${e.$2}](around:$distance,${position.latitude}, ${position.longitude});')
        .join();

    final data = """
        [out:json][timeout:$_timeout];
        ($tagsFormatted);
        out center;""";
    return dio.post('', data: data).then((value) {
      if (value.statusCode != HttpStatus.ok) {
        return Future.error("Error performing query");
      }
      final List data = value.data['elements'];
      final res = data
          .map((e) => POI.fromJson(e, position))
          .where((poi) => poi.distanceInKm * 1000 > distance - distance * 0.2)
          .where((poi) => poi.tags.containsKey('name'))
          .toList();
      res.sort((a, b) => a.distanceInKm.compareTo(b.distanceInKm));

      print('Distance: $distance');
      print('Distance 20% : ${distance * 0.2}');
      print('Size: ${res.length}');
      return res;
    });
  }
}
