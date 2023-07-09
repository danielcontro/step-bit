import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepbit/database/entities/discount.dart';
import 'package:stepbit/database/entities/favorite.dart';
import 'package:stepbit/repositories/database_repository.dart';
import 'package:stepbit/utils/token_manager.dart';

import '../widgets/favorite_card.dart';
import '../widgets/loading.dart';

class Deals extends StatelessWidget {
  const Deals({Key? key}) : super(key: key);

  Future<List<Favorite>> _findFavorites(DatabaseRepository dbr) async {
    final username = await TokenManager.getUsername();
    final discounts = await dbr.findDiscountsByUsername(username!);
    final favoritesIds = discounts.map((e) => e.favoriteId);
    List<Favorite> favorites = List.empty(growable: true);
    for (var id in favoritesIds) {
      favorites.add((await dbr.database.favoriteDao.findFavoriteById(id))!);
    }
    return favorites;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Deals",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Consumer<DatabaseRepository>(
          builder: (context, dbr, child) {
            return FutureBuilder<List<Favorite>>(
              future: _findFavorites(dbr),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
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
                          child: Text(
                              "Complete the daily goal and request discounts to be able to see them")),
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
