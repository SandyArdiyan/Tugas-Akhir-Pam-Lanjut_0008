// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import '../utils/constants.dart';
import '../../data/storage/secure_storage_helper.dart';

class DioClient {
  final Dio _dio;
  final SecureStorageHelper _storageHelper;

  DioClient(this._storageHelper) : _dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl)) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Jika request BUKAN ke Google Books, masukkan JWT Token
          if (!options.path.contains('googleapis')) {
             final token = await _storageHelper.getToken();
             if (token != null) {
               options.headers['Authorization'] = 'Bearer $token';
             }
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Jika backend membalas 401 Unauthorized (Token Expired)
          if (e.response?.statusCode == 401) {
            _storageHelper.deleteToken(); // Paksa hapus token
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}