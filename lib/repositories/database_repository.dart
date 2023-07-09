import 'package:flutter/material.dart';
import 'package:stepbit/database/entities/discount.dart';
import 'package:stepbit/database/entities/favorite.dart';
import 'package:stepbit/database/entities/person_favorite.dart';
import 'package:stepbit/utils/token_manager.dart';

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
            0 &&
        await database.discountDao.numberOfEntriesFromFavoriteId(favorite.id) ==
            0) {
      await database.favoriteDao.deleteFavorite(favorite);
    }
    notifyListeners();
  }

  Future<void> addNewFavorite(
    Favorite favorite,
  ) async {
    await database.favoriteDao.insertFavorite(favorite);
    notifyListeners();
  }

  Future<void> addNewPersonFavorite(
    Favorite favorite,
    PersonFavorite personFavorite,
  ) async {
    await database.favoriteDao.insertFavorite(favorite);
    await database.personFavoriteDao.insertPersonFavorite(personFavorite);
    notifyListeners();
  }

  Future<Favorite?> findFavoriteByName(String name) async {
    return database.personFavoriteDao.findFavoriteByUsernameAndFavoriteName(
        (await TokenManager.getUsername())!, name);
  }

  Future<List<Favorite>> findFavoritesByPersonUsername(String username) {
    return database.personFavoriteDao.findFavoritesByPersonUsername(username);
  }

  Future<Discount?> getDiscount(String username, String favoriteName) async {
    final discount = await database.discountDao
        .getDiscountFromUsernameAndFavoriteName(username, favoriteName);

    if (discount == null) return null;
    if (discount.isExpired()) {
      await deleteDiscount(discount);
      return null;
    }
    return discount;
  }

  Future<void> addNewDiscount(Discount discount) async {
    await database.discountDao.insertDiscount(discount);
    notifyListeners();
  }

  Future<void> deleteDiscount(Discount discount) async {
    await database.discountDao.deleteDiscount(discount);
    notifyListeners();
    return;
  }

  Future<List<Discount>> findDiscountsByUsername(String username) async {
    var discounts =
        await database.discountDao.findDiscountsByUsername(username);
    for (var discount in discounts) {
      if (discount.isExpired()) {
        discounts.remove(discount);
        await deleteDiscount(discount);
      }
    }
    return discounts;
  }
}
