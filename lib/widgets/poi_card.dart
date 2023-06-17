import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepbit/database/entities/favorite.dart';
import 'package:stepbit/database/entities/person_favorite.dart';
import 'package:stepbit/models/poi.dart';

import '../repositories/database_repository.dart';

class PoiCard extends StatelessWidget {
  final POI poi;

  const PoiCard({super.key, required this.poi});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseRepository>(builder: (context, dbr, child) {
      return StreamBuilder(
        builder: (context, snapshot) {
          try {
            return const Text('');
          } catch (Exc) {
            return const Text('');
          }
        },
      );
    });
  }
  //The logic is to query the DB for the entire list of Meal using dbr.findAllMeals()
  //and then populate the ListView accordingly.
  //We need to use a FutureBuilder since the result of dbr.findAllMeals() is a Future.
  /*return StreamBuilder(
          stream: dbr.database.favoriteDao.findFavoriteByName(poi.getName()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data as Favorite;
              Dismissible(
                key: UniqueKey(),
                background: Container(
                  color: Colors.red,
                  child: const Icon(Icons.delete),
                ),
                onDismissed: (direction) async {
                  await Provider.of<DatabaseRepository>(context, listen: false)
                      .removePersonFavorite(PersonFavorite(1, data.id));
                },
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
            } else {
              return const Text('');
            }
          });
    });
  }*/
}
