import 'package:floor/floor.dart';

import 'favorite.dart';
import 'person.dart';

@Entity(
  tableName: 'PersonFavorite',
  primaryKeys: ['personId', 'favoriteId'],
  foreignKeys: [
    ForeignKey(
        childColumns: ['personId'],
        parentColumns: ['id'],
        entity: Person,
        onUpdate: ForeignKeyAction.cascade,
        onDelete: ForeignKeyAction.cascade),
    ForeignKey(
      childColumns: ['favoriteId'],
      parentColumns: ['id'],
      entity: Favorite,
      onUpdate: ForeignKeyAction.cascade,
      onDelete: ForeignKeyAction.cascade,
    )
  ],
)
class PersonFavorite {
  final int personId;
  final String favoriteId;

  PersonFavorite(this.personId, this.favoriteId);
}
