import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:stepbit/database/entities/favorite.dart';

import '../repositories/database_repository.dart';

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
            .deleteFavorite(favorite);
      },
      child: ListTile(
        leading: favorite.getIcon(),
        title: Text(favorite.name, overflow: TextOverflow.ellipsis),
        subtitle: Row(
          children: [
            const Icon(Icons.location_city, size: 15),
            Text(favorite.city),
          ],
        ),
        onTap: () async {
          final availableMaps = await MapLauncher.installedMaps;
          if (availableMaps.isNotEmpty) {
            await availableMaps.first.showMarker(
              coords: Coords(favorite.lat, favorite.lng),
              title: favorite.name,
            );
          }
        },
      ),
    );
  }
}
