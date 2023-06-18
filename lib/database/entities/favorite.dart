import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

@Entity(tableName: 'Favorite', primaryKeys: ['id'])
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

  Icon getIcon() {
    return switch (type.toLowerCase()) {
      "artwork" || "gallery" => const Icon(Icons.photo),
      "attraction" => const Icon(Icons.attractions),
      "viewpoint" => const Icon(Icons.panorama),
      "museum" => const Icon(Icons.museum),
      "church" || "chapel" || "place_of_worship" => const Icon(Icons.church),
      "university" => const Icon(Icons.school),
      "restaurant" ||
      "fast_food" ||
      "bar" ||
      "cafe" ||
      "pub" ||
      "food_court" =>
        const Icon(Icons.restaurant),
      "ice_cream" => const Icon(Icons.icecream),
      "marketplace" => const Icon(Icons.shopping_cart),
      _ => const Icon(Icons.question_mark)
    };
  }
}
