import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stepbit/database/entities/favorite.dart';
import 'package:stepbit/models/poi.dart';
import 'package:stepbit/utils/position.dart';

import '../repositories/database_repository.dart';
import '../screens/view_poi.dart';

class FavoriteCard extends StatelessWidget {
  final Favorite favorite;

  const FavoriteCard({super.key, required this.favorite});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: const Icon(Icons.delete),
      ),
      onDismissed: (direction) async {
        await Provider.of<DatabaseRepository>(context, listen: false)
            .deleteFavorite(1, favorite);
      },
      child: ListTile(
        leading: POI.getIcon(favorite.type),
        title: Text(favorite.name, overflow: TextOverflow.ellipsis),
        subtitle: Row(
          children: [
            const Icon(Icons.location_city, size: 15),
            Text(favorite.city),
          ],
        ),
        onTap: () {
          Position.getCurrentPosition()?.then((value) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewPOI(
                        poi: POI(
                            position: LatLng(favorite.lat, favorite.lng),
                            tags: {
                              "name": favorite.name,
                              "tourism": favorite.type
                            },
                            distanceInKm: POI.getDistanceInKm(
                                favorite.lat,
                                favorite.lng,
                                value.latitude,
                                value.longitude)))));
          });
        },
      ),
    );
  }
}
