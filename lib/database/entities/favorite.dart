// entity/favorite.dart

import 'package:floor/floor.dart';

@Entity(tableName: 'Favorite', primaryKeys: ['id'])
class Favorite {
  final int id;
  final String name;
  final String? city;
  final double lat;
  final double lng;
  final String? address;
  final String website;
  final String type;

  Favorite(this.id, this.name, this.city, this.lat, this.lng, this.address,
      this.website, this.type);
}
