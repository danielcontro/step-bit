import 'package:flutter/material.dart';
import 'package:stepbit/models/poi.dart';

class PoiCard extends StatelessWidget {
  final POI poi;

  const PoiCard({super.key, required this.poi});

  Icon getPoiIcon() {
    if (poi.getType().toLowerCase() == "museum") {
      return const Icon(Icons.museum);
    } else {
      return const Icon(Icons.question_mark);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: getPoiIcon(),
      title: Text(poi.getName()),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (poi.getCity() != null)
            Row(children: [
              const Icon(Icons.location_city, size: 15),
              Text(poi.getCity()!),
            ]),
          Row(children: [
            const Icon(Icons.pin_drop, size: 15),
            Text('${poi.latitude} ${poi.longitude}'),
          ])
        ],
      ),
    );
  }
}
