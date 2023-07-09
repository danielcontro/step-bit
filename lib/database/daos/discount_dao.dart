import 'package:floor/floor.dart';
import 'package:stepbit/database/entities/discount.dart';

@dao
abstract class DiscountDao {
  @Query('''
    SELECT Discounts.*
    FROM Discounts
    INNER JOIN Favorite ON Favorite.id = Discounts.favoriteId
    WHERE Discounts.username = :username AND Favorite.name = :favoriteName
  ''')
  Future<Discount?> getDiscountFromUsernameAndFavoriteName(
      String username, String favoriteName);

  @delete
  Future<void> deleteDiscount(Discount discount);

  @insert
  Future<void> insertDiscount(Discount discount);

  @Query('''
    SELECT *
    FROM Discounts
    WHERE username = :username
  ''')
  Future<List<Discount>> findDiscountsByUsername(String username);

  @Query('''
    SELECT COUNT(*)
    FROM Discounts
    WHERE favoriteId = :favoriteId
  ''')
  Future<int?> numberOfEntriesFromFavoriteId(String favoriteId);
}
