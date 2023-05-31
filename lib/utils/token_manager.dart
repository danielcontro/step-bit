import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const _accessToken = 'access_token';
  static const _refreshToken = 'refresh_token';

  static const storage = FlutterSecureStorage();

  static Future<String?> getAccessToken() => storage.read(key: _accessToken);

  static Future<String?> getRefreshToken() => storage.read(key: _refreshToken);

  static Future<void> saveTokens(Map<String, dynamic> json) async {
    await storage.write(key: _accessToken, value: json['access']);
    await storage.write(key: _refreshToken, value: json['refresh']);
  }

  static Future<void> clearTokens() async {
    await storage.delete(key: _accessToken);
    await storage.delete(key: _refreshToken);
  }
}
