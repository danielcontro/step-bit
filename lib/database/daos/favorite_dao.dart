import 'package:floor/floor.dart';
import '../entities/favorite.dart';

@dao
abstract class FavoriteDao {
  @Query('SELECT * FROM Favorite')
  Future<List<Favorite>> findAllFavorite();

  @Query('SELECT name FROM Favorite')
  Stream<List<String>> findFavoriteByName();

  @Query('SELECT * FROM Favorite WHERE id = :id')
  Stream<Favorite?> findFavoriteById(int id);

  @insert
  Future<void> insertFavorite(Favorite favorite);

  @delete
  Future<void> deleteFavorite(Favorite favorite);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateFavortie(Favorite favorite);
}
