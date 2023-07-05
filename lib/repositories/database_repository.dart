import 'package:flutter/material.dart';
import 'package:stepbit/database/entities/favorite.dart';
import 'package:stepbit/database/entities/person_favorite.dart';

import '../database/database.dart';
import '../database/entities/person.dart';

class DatabaseRepository extends ChangeNotifier {
  final AppDatabase database;

  DatabaseRepository({required this.database});

  Future<void> addPersonIfNotPresent(Person person) async {
    final personDB =
        await database.personDao.findPersonByUsername(person.username);
    if (personDB == null) {
      await database.personDao.insertPerson(person);
      notifyListeners();
    }
  }

  Future<void> deleteFavorite(String username, Favorite favorite) async {
    await database.personFavoriteDao
        .deletePersonFavoriteFromIds(username, favorite.id);

    if ((await database.personFavoriteDao
            .numberOfEntriesFromFavoriteId(favorite.id)) ==
        0) {
      await database.favoriteDao.deleteFavorite(favorite);
    }
    notifyListeners();
  }

  Future<void> addNewFavorite(
    Favorite favorite,
    PersonFavorite personFavorite,
  ) async {
    await database.favoriteDao.insertFavorite(favorite);
    await database.personFavoriteDao.insertPersonFavorite(personFavorite);
    notifyListeners();
  }

  Future<Favorite?> findFavoriteByName(String name) {
    return database.favoriteDao.findFavoriteByName(name);
  }

  Future<bool?> isFavorite(String name) {
    return database.favoriteDao
        .findFavoriteByName(name)
        .then((value) => value == null ? false : true);
  }

  Future<List<Favorite>> findFavoritesByPersonUsername(String username) {
    return database.personFavoriteDao.findFavoritesByPersonUsername(username);
  }
}
