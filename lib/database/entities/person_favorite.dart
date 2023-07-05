import 'package:floor/floor.dart';

import 'favorite.dart';
import 'person.dart';

@Entity(
  tableName: 'PersonFavorite',
  primaryKeys: ['personId', 'favoriteId'],
  foreignKeys: [
    ForeignKey(
        childColumns: ['personUsername'],
        parentColumns: ['username'],
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
  final String personUsername;
  final String favoriteId;

  PersonFavorite(this.personUsername, this.favoriteId);
}
