import 'package:floor/floor.dart';
import '../entities/favorite.dart';

@dao
abstract class FavoriteDao {
  /*@Query('SELECT * FROM Favorite')
  Future<List<Favorite>> findAllFavorite();

  @Query('SELECT * FROM Favorite WHERE id = :id')
  Stream<Favorite?> findFavoriteById(int id);

  @Query('SELECT * FROM Favorite WHERE lat = :lat AND lng = :lng')
  Stream<Favorite?> findFavoriteByPosition(double lat, double lng);*/

  @Query('SELECT * FROM Favorite WHERE name = :name')
  Future<Favorite?> findFavoriteByName(String name);

  @insert
  Future<void> insertFavorite(Favorite favorite);

  @delete
  Future<void> deleteFavorite(Favorite favorite);

  /*@Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateFavortie(Favorite favorite);*/
}
