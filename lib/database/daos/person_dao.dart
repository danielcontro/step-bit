import 'package:floor/floor.dart';

import '../entities/person.dart';

@dao
abstract class PersonDao {
  @Query('SELECT * FROM Person')
  Future<List<Person>> findAllPeople();

  @Query('SELECT name FROM Person')
  Stream<List<String>> findAllPeopleName();

  @Query('SELECT * FROM Person WHERE id = :id')
  Stream<Person?> findPersonById(int id);

  @insert
  Future<void> insertPerson(Person person);

  @delete
  Future<void> deletePerson(Person person);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updatePerson(Person person);
}
