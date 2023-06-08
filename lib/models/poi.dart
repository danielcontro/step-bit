/*
tourism = [artwork, attraction, viewpoint, museum, gallery, ]
building = [church, university, chapel, ]
historic = [building, ]
amenity = [place_of_worship, restaurant, fast_food, cafe, bar, pub, food_court, ice_cream, marketplace]
*/
class POI {
  //final POIType type;
  final double latitude;
  final double longitude;
  final Map<String, dynamic> tags;

  const POI({
    //required this.type,
    required this.latitude,
    required this.longitude,
    required this.tags,
  });

  factory POI.fromJson(Map<String, dynamic> json) {
    return POI(
        //type: POIType.node,
        latitude: json['lat'],
        longitude: json['lon'],
        tags: json['tags']);
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

  @override
  String toString() {
    var tagsFormatted = tags.entries
        .fold('', (previousValue, element) => '$previousValue, $element');
    return 'POI(latitude: $latitude, longitude: $longitude, tags: $tagsFormatted)';
  }
}
