import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; 
import '../models/book_model.dart';

class BookRepository {
  final Dio _dio = Dio();
  
  // API Key resmi milikmu
  final String apiKey = "AIzaSyD4GGjsMtSOkehkXMDbgbGMReFTu9xB5ZQ"; 

  Future<List<BookModel>> searchBooks(String query, {int startIndex = 0}) async {
    try {
      if (query.trim().isEmpty) return [];

      final response = await _dio.get(
        'https://www.googleapis.com/books/v1/volumes', 
        queryParameters: {
          'q': query,
          'startIndex': startIndex,
          'maxResults': 10,
          'key': apiKey, // API Key disisipkan di sini agar Google tidak memblokir
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
      throw Exception('Gagal memuat buku. Pastikan internet stabil dan API key valid.');
    }
  }
}