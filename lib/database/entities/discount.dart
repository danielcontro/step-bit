import 'package:floor/floor.dart';
import 'package:stepbit/database/entities/person.dart';

import 'favorite.dart';

@Entity(tableName: 'Discounts', foreignKeys: [
  ForeignKey(
    childColumns: ['favoriteId'],
    parentColumns: ['id'],
    entity: Favorite,
    onUpdate: ForeignKeyAction.cascade,
    onDelete: ForeignKeyAction.cascade,
  ),
  ForeignKey(
    childColumns: ['userId'],
    parentColumns: ['id'],
    entity: Person,
    onUpdate: ForeignKeyAction.cascade,
    onDelete: ForeignKeyAction.cascade,
  )
])
class Discount {
  @PrimaryKey()
  final String id;
  final String favoriteId;
  final String userId;
  final String description;
  final DateTime issued;
  final DateTime expires;

  Discount(this.id, this.favoriteId, this.userId, this.description, this.issued,
      this.expires);
}
