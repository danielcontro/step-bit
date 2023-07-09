import 'package:floor/floor.dart';
import '../entities/favorite.dart';

@dao
abstract class FavoriteDao {
  @Query('SELECT * FROM Favorite WHERE name = :name')
  Future<Favorite?> findFavoriteByName(String name);

  @Query('SELECT * FROM Favorite WHERE id = :id')
  Future<Favorite?> findFavoriteById(String id);

  @insert
  Future<void> insertFavorite(Favorite favorite);

  @delete
  Future<void> deleteFavorite(Favorite favorite);
}
