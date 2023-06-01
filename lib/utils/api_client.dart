import 'dart:io';
import 'package:intl/intl.dart';
import 'package:stepbit/utils/app_interceptor.dart';
import 'package:stepbit/utils/token_manager.dart';

import '../models/distance.dart';
import '../models/exercise.dart';
import '../models/steps.dart';

class ApiClient {
  static const _patientUsername = 'Jpefaq6m58';
  static const _tokenEndpoint = 'gate/v1/token/';

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

  static Future<List<Steps>?> getSteps(DateTime date) {
    var newFormat = DateFormat('y-MM-dd');
    final dateFormatted = newFormat.format(date);

    return _client
        .get('data/v1/steps/patients/$_patientUsername/day/$dateFormatted/')
        .then((value) {
      if (value.statusCode != HttpStatus.ok) {
        return null;
      }
      final data = value.data['data']['data'];
      return data
          .cast<Map<String, dynamic>>()
          .map<Steps>((json) => Steps.fromJson(dateFormatted, json))
          .toList();
    });
 }

 static Future<List<Distance>?> getDistance(DateTime date) {
    var newFormat = DateFormat('y-MM-dd');
    final dateFormatted = newFormat.format(date);

    return _client
        .get('data/v1/distance/patients/$_patientUsername/day/$dateFormatted/')
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

 static Future<List<Exercise>?> getExercises(DateTime date) {
    var newFormat = DateFormat('y-MM-dd');
    final dateFormatted = newFormat.format(date);

    return _client
        .get('data/v1/exercise/patients/$_patientUsername/day/$dateFormatted/')
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
}
