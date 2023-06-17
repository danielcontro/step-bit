import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepbit/database/entities/favorite.dart';
import 'package:stepbit/mapper/to_poi.dart';
import 'package:stepbit/models/poi.dart';
import 'package:stepbit/utils/overpass_api.dart';
import 'package:stepbit/utils/position.dart';

import '../repositories/database_repository.dart';
import '../widgets/poi_card.dart';

class Favorites extends StatelessWidget {
  late final double data;
  final toPOI = ToPOI();

  Favorites({Key? key, required data}) : super(key: key) {
    this.data = data * 500;
  }

  Future<List<POI>> buildQuery(double distance) async {
    final currentPosition = await getCurrentPosition();
    if (currentPosition != null) {
      return OverpassApi().query([
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
        "Favorites",
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
      Consumer<DatabaseRepository>(
        builder: (context, dbr, child) {
          return FutureBuilder(
            future: dbr.database.personFavoriteDao.findFavoritesByPersonId(1),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data as List<Favorite>;
                if (data.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      prototypeItem: PoiCard(poi: toPOI(data.first)),
                      itemCount: data.length,
                      itemBuilder: (context, index) =>
                          PoiCard(poi: toPOI(data[index])),
                    ),
                  );
                } else {
                  return const Text("No POI near you");
                }
              } else {
                return const Text("No Favorites");
              }
            },
          );
        },
      ),
      /*FutureBuilder(
          future: buildQuery(data),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<POI> poi = snapshot.data!;
              if (poi.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    prototypeItem: PoiCard(poi: poi.first),
                    itemCount: poi.length,
                    itemBuilder: (context, index) => PoiCard(poi: poi[index]),
                  ),
                );
              } else {
                return const Text("No POI near you");
              }
            } else {
              return const Loading();
            }
          }),*/
    ]);
  }
}
