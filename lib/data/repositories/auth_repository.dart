import 'package:dio/dio.dart'; // Tambahan wajib untuk menangkap error API
import '../../core/network/dio_client.dart';
import '../storage/secure_storage_helper.dart';

class AuthRepository {
  final DioClient _dioClient;
  final SecureStorageHelper _storageHelper;

  AuthRepository(this._dioClient, this._storageHelper);

  Future<bool> login(String email, String password) async {
    try {
      final response = await _dioClient.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final String token = response.data['token'];
        await _storageHelper.saveToken(token);
        return true;
      }
      return false;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        // Ambil pesan error dari Node.js
        throw Exception(e.response?.data['message'] ?? 'Login gagal');
      }
      throw Exception('Tidak bisa terhubung ke server. Backend mati?');
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      final response = await _dioClient.dio.post('/auth/register', data: {
        'email': email,
        'password': password,
      });
      return response.statusCode == 201; // Created
    } on DioException catch (e) {
      // INI PERBAIKANNYA: Tangkap pesan error ASLI dari Backend
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Gagal mendaftar');
      }
      throw Exception('Gagal terhubung ke Backend. Pastikan Node.js menyala!');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<void> logout() async {
    await _storageHelper.deleteToken();
  }
}