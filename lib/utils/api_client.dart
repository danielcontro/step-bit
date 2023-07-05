import 'dart:io';
import 'package:intl/intl.dart';
import 'package:stepbit/utils/app_interceptor.dart';
import 'package:stepbit/utils/token_manager.dart';

import '../models/distance.dart';
import '../models/exercise.dart';
import '../models/patient.dart';
import '../models/steps.dart';

class ApiClient {
  static const _tokenEndpoint = 'gate/v1/token/';
  static const _patientsEndpoint = 'study/v1/patients/';

  static final _client = AppInterceptor().dio;

  static Future<bool> login(String username, String password) {
    final body = {'username': username, 'password': password};
    return _client.post(_tokenEndpoint, data: body).then((value) async {
      if (value.statusCode == HttpStatus.ok) {
        await TokenManager.saveTokens(value.data);
        return true;
      }
      return false;
    });
  }

  static Future<List<Patient>?> patients() {
    return _client.get(_patientsEndpoint).then((value) async {
      if (value.statusCode != HttpStatus.ok) {
        return null;
      }
      final data = value.data['data'];
      return data
          .cast<Map<String, dynamic>>()
          .map<Patient>((json) => Patient.fromJson(json))
          .toList();
    });
  }

  static Future<List<Steps>?> getSteps(DateTime date) async {
    var newFormat = DateFormat('y-MM-dd');
    final dateFormatted = newFormat.format(date);
    final patientUsername = await TokenManager.getUsername();

    return _client
        .get('data/v1/steps/patients/$patientUsername/day/$dateFormatted/')
        .then((value) {
      if (value.statusCode != HttpStatus.ok) {
        return null;
      }
      try {
        final data = value.data['data']['data'];
        return data
            .cast<Map<String, dynamic>>()
            .map<Steps>((json) => Steps.fromJson(dateFormatted, json))
            .toList();
      } catch (e) {
        return List.empty();
      }
    });
  }

  static Future<List<Distance>?> getDistance(DateTime date) async {
    var newFormat = DateFormat('y-MM-dd');
    final dateFormatted = newFormat.format(date);
    final patientUsername = await TokenManager.getUsername();

    return _client
        .get('data/v1/distance/patients/$patientUsername/day/$dateFormatted/')
        .then((value) {
      if (value.statusCode != HttpStatus.ok) {
        return null;
      }
      final data = value.data['data']['data'];
      return data
          .cast<Map<String, dynamic>>()
          .map<Distance>((json) => Distance.fromJson(dateFormatted, json))
          .toList();
    });
  }

  static Future<List<Exercise>?> getExercises(DateTime date) async {
    var newFormat = DateFormat('y-MM-dd');
    final dateFormatted = newFormat.format(date);
    final patientUsername = await TokenManager.getUsername();

    return _client
        .get('data/v1/exercise/patients/$patientUsername/day/$dateFormatted/')
        .then((value) {
      if (value.statusCode != HttpStatus.ok) {
        return null;
      }
      final data = value.data['data']['data'];
      return data
          .cast<Map<String, dynamic>>()
          .map<Exercise>((json) => Exercise.fromJson(dateFormatted, json))
          .toList();
    });
  }

  static Future<List<Exercise>?> getExercisesStartEnd(
      DateTime startDate, DateTime endDate) async {
    var newFormat = DateFormat('y-MM-dd');
    final startDateFormatted = newFormat.format(startDate);
    final endDateFormatted = newFormat.format(endDate);
    final patientUsername = await TokenManager.getUsername();

    return _client
        .get(
            'data/v1/exercise/patients/$patientUsername/daterange/start_date/$startDateFormatted/end_date/$endDateFormatted/')
        .then((value) {
      if (value.statusCode != HttpStatus.ok) {
        return null;
      }
      final data = value.data['data'] as List<dynamic>;
      List<Exercise> results = [];
      for (var exercise in data) {
        var date = exercise['date'];
        var exerciseDay = exercise['data']
            .cast<Map<String, dynamic>>()
            .map<Exercise>((json) => Exercise.fromJson(date, json))
            .toList();
        results.addAll(exerciseDay);
      }
      return results.reversed.toList();
    });
  }
}
