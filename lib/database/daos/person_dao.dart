import 'package:floor/floor.dart';

import '../entities/person.dart';

// dart run build_runner build

@dao
abstract class PersonDao {
  /*@Query('SELECT * FROM Person')
  Future<List<Person>> findAllPeople();

  @Query('SELECT name FROM Person')
  Stream<List<String>> findAllPeopleName();*/

  @Query('SELECT * FROM Person WHERE id = :id')
  Future<Person?> findPersonById(int id);

  /*@Query('SELECT COUNT(*) FROM Person')
  Future<int?> countRows();*/

  @insert
  Future<void> insertPerson(Person person);

  /*@Update(onConflict: OnConflictStrategy.replace)
  Future<void> updatePerson(Person person);*/
}
