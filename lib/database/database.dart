import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:stepbit/database/daos/discount_dao.dart';
import 'package:stepbit/database/entities/discount.dart';
import 'package:stepbit/database/type_converters/datetime_type_converter.dart';

import 'daos/person_favorite_dao.dart';
import 'entities/person_favorite.dart';
import 'daos/person_dao.dart';
import 'daos/favorite_dao.dart';
import 'entities/person.dart';
import 'entities/favorite.dart';

part 'database.g.dart'; // the generated code will be there

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [Person, Favorite, PersonFavorite, Discount])
abstract class AppDatabase extends FloorDatabase {
  PersonDao get personDao;
  FavoriteDao get favoriteDao;
  PersonFavoriteDao get personFavoriteDao;
  DiscountDao get discountDao;
}
