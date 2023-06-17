import 'package:flutter/material.dart';
import 'package:stepbit/database/entities/favorite.dart';

class FavoriteCard extends StatelessWidget {
  final Favorite favorite;

  const FavoriteCard({super.key, required this.favorite});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<String>(favorite.id),
      background: Container(
        color: Colors.red,
        child: const Icon(Icons.delete),
      ),
      onDismissed: (direction) {},
      child: ListTile(
        leading: favorite.getIcon(),
        title: Text(favorite.name, overflow: TextOverflow.ellipsis),
        subtitle: Row(
          children: [
            const Icon(Icons.location_city, size: 15),
            Text(favorite.city),
          ],
        ),
      ),
    );
  }
}
