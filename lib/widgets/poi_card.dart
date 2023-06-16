import 'package:flutter/material.dart';
import 'package:stepbit/models/poi.dart';

class PoiCard extends StatelessWidget {
  final POI poi;

  const PoiCard({super.key, required this.poi});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: const Icon(Icons.delete),
      ),
      onDismissed: (direction) {},
      child: ListTile(
        leading: poi.getIcon(),
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
          ],
        ),
      ),
    );
  }
}
