//joints
import 'package:floor/floor.dart';

import '../entities/person_favorite.dart';

@dao
abstract class PersonFavoriteDao {
  @Query('SELECT * FROM PersonFavorite WHERE personId = :id')
  Stream<PersonFavorite?> findFavoritesByPersonId(int id);

  @Query('SELECT * FROM PersonFavorite WHERE favoriteId = :id')
  Stream<PersonFavorite?> findPeopleByFavoriteId(int id);

  @insert
  Future<void> insertPersonFavorite(PersonFavorite personFavorite);

  @delete
  Future<void> deletePersonFavorite(PersonFavorite personFavorite);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updatePersonFavorite(PersonFavorite personFavorite);
}
