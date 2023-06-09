import 'package:flutter/material.dart';
import 'package:stepbit/models/poi.dart';
import 'package:stepbit/utils/overpass_api.dart';
import 'package:stepbit/utils/position.dart';
import 'package:stepbit/widgets/loading.dart';
import 'package:stepbit/widgets/poi_card.dart';

class Favorites extends StatelessWidget {
  late final double data;

  Favorites({Key? key, required data}) : super(key: key) {
    this.data = data * 500;
  }

  Future<List<POI>> buildQuery(double distance) async {
    final currentPosition = await getCurrentPosition();
    if (currentPosition != null) {
      return OverpassApi.query([
        ('tourism', 'attraction'),
        ('tourism', 'viewpoint'),
        ('tourism', 'museum'),
        ('tourism', 'gallery'),
        ('building', 'church'),
        ('building', 'chapel'),
        ('historic', 'building'),
        ('amenity', 'restaurant'),
        ('amenity', 'bar'),
        ('amenity', 'ice_cream'),
      ], currentPosition, distance);
    }
    return Future.error('Unable to fetch location');
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        "TEST",
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
      FutureBuilder(
          future: buildQuery(data),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<POI> poi = snapshot.data!;
              return Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  //prototypeItem: PoiCard(poi: poi.first),
                  itemCount: poi.length,
                  itemBuilder: (context, index) {
                    return PoiCard(poi: poi[index]);
                  },
                ),
              );
            } else {
              return const Loading();
            }
          }),
    ]);
  }
}
