import 'package:floor/floor.dart';

import '../entities/favorite.dart';
import '../entities/person_favorite.dart';

@dao
abstract class PersonFavoriteDao {
  @Query('''
    SELECT Favorite.*
    FROM PersonFavorite
    INNER JOIN Favorite ON Favorite.id = PersonFavorite.favoriteId
    WHERE personId = :personId
  ''')
  Future<List<Favorite>> findFavoritesByPersonId(int personId);

  @insert
  Future<void> insertPersonFavorite(PersonFavorite personFavorite);

  @Query('''
    DELETE FROM PersonFavorite
    WHERE personId = :personId AND favoriteId = :favoriteId
  ''')
  Future<void> deletePersonFavoriteFromIds(int personId, String favoriteId);

  @Query('''
    SELECT COUNT(*)
    FROM PersonFavorite
    INNER JOIN Favorite ON Favorite.id = PersonFavorite.favoriteId
    WHERE favoriteId = :favoriteId
  ''')
  Future<int?> numberOfEntriesFromFavoriteId(String favoriteId);
}
