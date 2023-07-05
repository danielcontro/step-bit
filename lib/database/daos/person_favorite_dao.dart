import 'package:floor/floor.dart';

import '../entities/favorite.dart';
import '../entities/person_favorite.dart';

@dao
abstract class PersonFavoriteDao {
  @Query('''
    SELECT Favorite.*
    FROM PersonFavorite
    INNER JOIN Favorite ON Favorite.id = PersonFavorite.favoriteId
    WHERE personUsername = :username
  ''')
  Future<List<Favorite>> findFavoritesByPersonUsername(String username);

  @insert
  Future<void> insertPersonFavorite(PersonFavorite personFavorite);

  @Query('''
    DELETE FROM PersonFavorite
    WHERE personUsername = :username AND favoriteId = :favoriteId
  ''')
  Future<void> deletePersonFavoriteFromIds(String username, String favoriteId);

  @Query('''
    SELECT COUNT(*)
    FROM PersonFavorite
    INNER JOIN Favorite ON Favorite.id = PersonFavorite.favoriteId
    WHERE favoriteId = :favoriteId
  ''')
  Future<int?> numberOfEntriesFromFavoriteId(String favoriteId);
}
