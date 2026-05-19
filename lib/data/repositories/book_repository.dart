import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; 
import '../../core/utils/constants.dart';
import '../models/book_model.dart';

class BookRepository {
  final Dio _dio = Dio();

  Future<List<BookModel>> searchBooks(String query, {int startIndex = 0}) async {
    try {
      if (query.trim().isEmpty) return [];

      final response = await _dio.get(
        AppConstants.googleBooksApiUrl,
        queryParameters: {
          'q': query,
          'startIndex': startIndex,
          'maxResults': 10, 
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final items = response.data['items'];
        
        if (items == null) {
          return [];
        }
        
        return (items as List).map((item) => BookModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('=== ERROR SEARCH BOOKS ===');
      debugPrint(e.toString());
      throw Exception('Gagal memuat buku: Periksa koneksi internet atau query pencarian.');
    }
  }
}