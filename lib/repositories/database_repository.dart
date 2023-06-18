import 'package:flutter/material.dart';
import 'package:stepbit/database/entities/favorite.dart';
import 'package:stepbit/database/entities/person_favorite.dart';

import '../database/database.dart';
import '../database/entities/person.dart';

class DatabaseRepository extends ChangeNotifier {
  final AppDatabase database;

  DatabaseRepository({required this.database});

  Future<List<Person>> findAllPeople() async {
    final results = await database.personDao.findAllPeople();
    return results;
  }

  //This method wraps the insertPerson() method of the DAO.
  //Then, it notifies the listeners that something changed.
  Future<void> insertPerson(Person person) async {
    await database.personDao.insertPerson(person);
    notifyListeners();
  }

  Future<void> updatePerson(Person person) async {
    await database.personDao.updatePerson(person);
    notifyListeners();
  }

  Future<void> deleteFavorite(Favorite favorite) async {
    await database.favoriteDao.deleteFavorite(favorite);
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
}