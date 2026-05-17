import 'package:dio/dio.dart';
import '../../core/utils/constants.dart';
import '../models/book_model.dart';

class BookRepository {
  final Dio _dio = Dio(); // Pakai Dio biasa karena tidak butuh JWT untuk Google API

  // startIndex = untuk pagination (mulai dari data ke berapa)
  Future<List<BookModel>> searchBooks(String query, {int startIndex = 0}) async {
    try {
      final response = await _dio.get(
        AppConstants.googleBooksApiUrl,
        queryParameters: {
          'q': query,
          'startIndex': startIndex,
          'maxResults': 10, // Pagination: Ambil 10 buku per load
        },
      );

      if (response.statusCode == 200 && response.data['items'] != null) {
        final List items = response.data['items'];
        return items.map((item) => BookModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Gagal memuat buku: $e');
    }
  }
}