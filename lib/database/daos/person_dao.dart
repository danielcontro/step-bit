import 'package:floor/floor.dart';

import '../entities/person.dart';

// dart run build_runner build

@dao
abstract class PersonDao {
  @Query('SELECT * FROM Person WHERE id = :id')
  Future<Person?> findPersonById(int id);

  @insert
  Future<void> insertPerson(Person person);
}
