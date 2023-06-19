import 'package:floor/floor.dart';

@Entity(tableName: 'Favorite')
class Favorite {
  @PrimaryKey()
  final String id;
  final String name;
  final String city;
  final double lat;
  final double lng;
  final String? address;
  final String type;

  Favorite(this.id, this.name, this.city, this.lat, this.lng, this.address,
      this.type);
}
