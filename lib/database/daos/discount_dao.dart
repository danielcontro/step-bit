import 'package:floor/floor.dart';
import 'package:stepbit/database/entities/discount.dart';

@dao
abstract class DiscountDao {
  @Query('SELECT * FROM Discounts WHERE userId = :userId')
  Future<Discount?> getDiscountOfUser(int userId);

  @delete
  Future<void> deleteDiscount(Discount discount);

  @insert
  Future<void> insertDiscount(Discount discount);
}
