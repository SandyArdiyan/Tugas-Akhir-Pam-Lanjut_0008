import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // Tambahkan ini untuk debugPrint
import '../utils/constants.dart';
import '../../data/storage/secure_storage_helper.dart';

class DioClient {
  final Dio _dio;
  final SecureStorageHelper _storageHelper;

  DioClient(this._storageHelper) : _dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10), // Tambahkan timeout agar tidak loading selamanya
    receiveTimeout: const Duration(seconds: 10),
  )) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Logika pengecekan yang lebih aman
          if (!options.uri.toString().contains('googleapis')) {
             final token = await _storageHelper.getToken();
             if (token != null && token.isNotEmpty) {
               options.headers['Authorization'] = 'Bearer $token';
             }
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Log error ke debug console
          debugPrint("Dio Error: ${e.response?.statusCode} - ${e.message}");
          
          if (e.response?.statusCode == 401) {
            _storageHelper.deleteToken();
            // Optional: Tambahkan event ke AuthBloc untuk redirect ke Login Screen
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}