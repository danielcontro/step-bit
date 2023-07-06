import 'package:floor/floor.dart';

import '../entities/person.dart';

// dart run build_runner build

@dao
abstract class PersonDao {
  @Query('SELECT * FROM Person WHERE username = :username')
  Future<Person?> findPersonByUsername(String username);

  @insert
  Future<void> insertPerson(Person person);
}
