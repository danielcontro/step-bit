import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepbit/database/entities/favorite.dart';
import 'package:stepbit/models/poi.dart';
import 'package:stepbit/utils/overpass_api.dart';
import 'package:stepbit/utils/position.dart';
import 'package:stepbit/widgets/loading.dart';

import '../repositories/database_repository.dart';
import '../widgets/favorite_card.dart';

class Favorites extends StatelessWidget {
  late final double data;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Favorites",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Consumer<DatabaseRepository>(
          builder: (context, dbr, child) {
            return FutureBuilder<List<Favorite>>(
              future: dbr.database.personFavoriteDao.findFavoritesByPersonId(1),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final favorites = snapshot.data!;
                  if (favorites.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        prototypeItem: FavoriteCard(favorite: favorites.first),
                        itemCount: favorites.length,
                        itemBuilder: (context, index) =>
                            FavoriteCard(favorite: favorites[index]),
                      ),
                    );
                  } else {
                    return ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                    );
                  }
                } else {
                  return const Loading();
                }
              },
            );
          },
        ),
      ],
    );
  }
}
