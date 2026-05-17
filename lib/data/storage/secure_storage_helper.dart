// lib/data/storage/secure_storage_helper.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'jwt_token';

  // Simpan Token setelah Login
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Ambil Token untuk Middleware
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Hapus Token saat Logout
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
  
  // Cek apakah user sedang login
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}