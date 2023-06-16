// entity/personFavorite.dart

import 'package:floor/floor.dart';

import 'favorite.dart';
import 'person.dart';

@Entity(
  tableName: 'PersonFavorite',
  primaryKeys: ['personId', 'favoriteId'],
  foreignKeys: [
    ForeignKey(
        childColumns: ['personId'], parentColumns: ['id'], entity: Person),
    ForeignKey(
        childColumns: ['favoriteId'], parentColumns: ['id'], entity: Favorite)
  ],
)
class PersonFavorite {
  @ColumnInfo(name: 'personId')
  final int personId;
  @ColumnInfo(name: 'favoriteId')
  final int favoriteId;

  PersonFavorite(this.personId, this.favoriteId);
}
