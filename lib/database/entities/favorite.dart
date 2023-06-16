// entity/favorite.dart

import 'package:floor/floor.dart';

@Entity(tableName: 'Favorite', primaryKeys: ['id'])
class Favorite {
  final int id;
  final String name;

  Favorite(this.id, this.name);
}
