import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepbit/database/entities/favorite.dart';
import 'package:stepbit/widgets/loading.dart';

import '../repositories/database_repository.dart';
import '../widgets/favorite_card.dart';

class Favorites extends StatelessWidget {
  const Favorites({Key? key}) : super(key: key);

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
              future: dbr.findFavoritesByPersonId(1),
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
                    return const Expanded(
                      child: Center(
                          child: Text("Go to the map to add a new favorite")),
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
