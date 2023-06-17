import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stepbit/database/entities/favorite.dart';

import '../models/poi.dart';
import 'mapper_interface.dart';

class ToPOI implements Mapper<Favorite, POI> {
  @override
  POI call(Favorite object) {
    String type = object.type;
    Map<String, dynamic> map = {
      'name': object.name,
      'addr:city': object.city,
      'addr:street': object.address,
      'website': object.website,
      type: type
    };
    return POI(
      position: LatLng(object.lat, object.lng),
      tags: map,
      distanceInKm: 0.0,
    );
  }
}
