import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const String baseUrl = 'https://impact.dei.unipd.it/bwthw/';
  static String pingEndpoint = 'gate/v1/ping/';
  static String tokenEndpoint = 'gate/v1/token/';
  static String refreshEndpoint = 'gate/v1/refresh/';

  static String? _accessToken;
  static String? _refreshToken;

  static Future<String?> getAccessToken() async {
    if (_accessToken == null) {
      final prefs = await SharedPreferences.getInstance();
      _accessToken = prefs.getString('access_token');
    }
    return _accessToken;
  }

  static Future<String?> getRefreshToken() async {
    if (_refreshToken == null) {
      final prefs = await SharedPreferences.getInstance();
      _refreshToken = prefs.getString('refresh_token');
    }
    return _refreshToken;
  }

  static Future<void> _saveTokens(
      String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  static Future<void> _clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    _accessToken = null;
    _refreshToken = null;
  }

  static Future<http.Response> _sendRequest(http.Request request) async {
    final response = await request.send();
    final responseString = await response.stream.bytesToString();
    if (response.statusCode == 401) {
      final isTokenRefreshed = await _refreshAccessToken();
      if (isTokenRefreshed) {
        // retry the request with the new access token
        request.headers['Authorization'] = 'Bearer $_accessToken';
        return _sendRequest(request);
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
      Uri.parse('$baseUrl/$tokenEndpoint'),
      body: {
        'refresh_token': refreshToken,
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final accessToken = jsonResponse['access_token'];
      final newRefreshToken = jsonResponse['refresh_token'];
      await _saveTokens(accessToken, newRefreshToken);
      return true;
    } else {
      await _clearTokens();
      return false;
    }
  }

  /*static Future<http.Response> get(String path,
      {Map<String, String> headers}) async {
    final request = http.Request('GET', Uri.parse('$BASE_URL/$path'));
    request.headers.addAll(headers ?? {});
    request.headers['Authorization'] = 'Bearer ${await getAccessToken()}';
    return _sendRequest(request);
  }*/

  /*static Future<http.Response> post(String path,
      {Map<String, String> headers, dynamic body}) async {
    final request = http.Request('POST', Uri.parse('$BASE_URL/$path'));
    request.headers.addAll(headers ?? {});
    request.headers['Authorization'] = 'Bearer ${await getAccessToken()}';
    request.body = json.encode(body ?? {});
    return _sendRequest(request);
  }*/

  static Future<bool> login(String username, String password) async {
    final body = {'username': username, 'password': password};
    final response =
        await http.post(Uri.parse('$baseUrl/$tokenEndpoint'), body: body);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      _saveTokens(decodedResponse['access'], decodedResponse['refresh']);
      return true;
    }
    return false;
  }
}
