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

  /*@Query('''
    SELECT Person.*
    FROM PersonFavorite
    INNER JOIN Person ON Person.id = PersonFavorite.personId
    WHERE favoriteId = :id
  ''')
  Stream<List<Person>?> findPeopleByFavoriteId(int id);*/

  @insert
  Future<void> insertPersonFavorite(PersonFavorite personFavorite);

  @delete
  Future<void> deletePersonFavorite(PersonFavorite personFavorite);

  /*@Update(onConflict: OnConflictStrategy.replace)
  Future<void> updatePersonFavorite(PersonFavorite personFavorite);*/
}
