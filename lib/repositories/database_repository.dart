import 'package:flutter/material.dart';

import '../database/database.dart';
import '../database/entities/person.dart';

class DatabaseRepository extends ChangeNotifier {
  //The state of the database is just the AppDatabase
  final AppDatabase database;

  //Default constructor
  DatabaseRepository({required this.database});

  Future<List<Person>> findAllPeople() async {
    final results = await database.personDao.findAllPeople();
    return results;
  }

  //This method wraps the insertPerson() method of the DAO.
  //Then, it notifies the listeners that something changed.
  Future<void> insertPerson(Person person) async {
    await database.personDao.insertPerson(person);
    notifyListeners();
  }

  //This method wraps the deleteMeal() method of the DAO.
  //Then, it notifies the listeners that something changed.
  Future<void> removePerson(Person person) async {
    await database.personDao.deletePerson(person);
    notifyListeners();
  }

  //This method wraps the updatePerson() method of the DAO.
  //Then, it notifies the listeners that something changed.
  Future<void> updatePerson(Person person) async {
    await database.personDao.updatePerson(person);
    notifyListeners();
  }
} //DatabaseRepository
