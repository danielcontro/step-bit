import 'package:floor/floor.dart';

import '../entities/favorite.dart';
import '../entities/person_favorite.dart';

@dao
abstract class PersonFavoriteDao {
  @Query('''
    SELECT Favorite.*
    FROM PersonFavorite
    INNER JOIN Favorite ON Favorite.id = PersonFavorite.favoriteId
    WHERE personId = :id
  ''')
  Future<List<Favorite>> findFavoritesByPersonId(int id);

  @insert
  Future<void> insertPersonFavorite(PersonFavorite personFavorite);
}
