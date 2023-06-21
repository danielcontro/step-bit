import 'package:floor/floor.dart';

@Entity(tableName: 'Person')
class Person {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String name;

  Person(this.id, this.name);
}
