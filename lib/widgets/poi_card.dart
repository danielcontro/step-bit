import 'package:flutter/material.dart';
import 'package:stepbit/models/poi.dart';

class PoiCard extends StatelessWidget {
  final POI poi;

  const PoiCard({super.key, required this.poi});

  Icon getPoiIcon() {
    return switch (poi.getType().toLowerCase()) {
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: getPoiIcon(),
      title: Text(poi.getName(), overflow: TextOverflow.ellipsis),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (poi.getCity() != null)
            Row(children: [
              const Icon(Icons.location_city, size: 15),
              Text(poi.getCity()!),
            ]),
          Row(children: [
            const Icon(Icons.timeline, size: 15),
            Text(poi.getDistanceKmOrMeters()),
          ]),
          /*Row(children: [
            const Icon(Icons.pin_drop, size: 15),
            Text('${poi.latitude} ${poi.longitude}'),
          ])*/
        ],
      ),
    );
  }
}
