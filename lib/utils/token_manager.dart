import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenManager {
  static const _accessToken = 'access_token';
  static const _refreshToken = 'refresh_token';

  static const _storage = FlutterSecureStorage();

  static Future<String?> getAccessToken() => _storage.read(key: _accessToken);

  static Future<String?> getRefreshToken() => _storage.read(key: _refreshToken);

  static Future<void> saveTokens(Map<String, dynamic> json) async {
    print("Token refreshed");
    await _storage.write(key: _accessToken, value: json['access']);
    await _storage.write(key: _refreshToken, value: json['refresh']);
  }

  static Future<void> clearTokens() async {
    await _storage.delete(key: _accessToken);
    await _storage.delete(key: _refreshToken);
  }

  static Future<bool> isTokenExpired() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) {
      return true;
    }
    final isExpired = JwtDecoder.isExpired(accessToken);
    if (!isExpired) {
      final seconds = JwtDecoder.getRemainingTime(accessToken).inSeconds;
      print("The token is still valid for $seconds seconds");
    }
    return isExpired;
  }
}