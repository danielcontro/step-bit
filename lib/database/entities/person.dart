import 'package:floor/floor.dart';

@Entity(tableName: 'Person')
class Person {
  @PrimaryKey()
  final String username;
  final String name;
  final int birthYear;

  Person(this.username, this.name, this.birthYear);
}
