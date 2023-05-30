import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/steps.dart';

class ApiClient {
  static const String baseUrl = 'https://impact.dei.unipd.it/bwthw/';
  static const String patientUsername = 'Jpefaq6m58';
  static String pingEndpoint = 'gate/v1/ping/';
  static String tokenEndpoint = 'gate/v1/token/';
  static String refreshEndpoint = 'gate/v1/refresh/';

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  static Future<void> _saveTokens(String jsonBody) async {
    final decodedResponse = jsonDecode(jsonBody);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', decodedResponse['access']);
    await prefs.setString('refresh_token', decodedResponse['refresh']);
  }

  static Future<void> _clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  static Future<http.Response> _sendRequest(http.Request request) async {
    final response = await request.send();
    final responseString = await response.stream.bytesToString();
    if (response.statusCode == 401) {
      final isTokenRefreshed = await _refreshAccessToken();
      if (isTokenRefreshed) {
        var newRequest = http.Request(request.method, request.url);
        newRequest.headers.addAll(request.headers);
        newRequest.headers['Authorization'] =
            'Bearer ${await getAccessToken()}';
        //newRequest.body = request.body;
        //newRequest.bodyFields = request.bodyFields;
        return _sendRequest(newRequest);
      }
    }
    return http.Response(responseString, response.statusCode);
  }

  static Future<bool> _refreshAccessToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      return false;
    }
    final response = await http.post(
      Uri.parse('$baseUrl/$refreshEndpoint'),
      body: {
        'refresh': refreshToken,
      },
    );
    if (response.statusCode == 200) {
      await _saveTokens(response.body);
      return true;
    } else {
      await _clearTokens();
      return false;
    }
  }

  static Future<bool> login(String username, String password) async {
    final body = {'username': username, 'password': password};
    final response =
        await http.post(Uri.parse('$baseUrl/$tokenEndpoint'), body: body);

    if (response.statusCode == 200) {
      _saveTokens(response.body);
      return true;
    }
    return false;
  }

  static Future<http.Response> _get(String path) async {
    final request = http.Request('GET', Uri.parse('$baseUrl/$path'));
    request.headers['Authorization'] = 'Bearer ${await getAccessToken()}';
    return _sendRequest(request);
  }

  static Future<List<Steps>?> getSteps(DateTime date) async {
    var newFormat = DateFormat("y-MM-dd");
    String dateFormatted = newFormat.format(date);

    final response = await _get(
        "data/v1/steps/patients/$patientUsername/day/$dateFormatted/");
    if (response.statusCode != 200) {
      return null;
    }
    final decodedResponse = jsonDecode(response.body)['data']['data'];
    final parsedJson = decodedResponse.cast<Map<String, dynamic>>();
    return parsedJson
        .map<Steps>((json) => Steps.fromJson(dateFormatted, json))
        .toList();
  }
}
