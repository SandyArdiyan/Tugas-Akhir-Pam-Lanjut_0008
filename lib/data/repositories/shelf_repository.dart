import 'package:dio/dio.dart';
import '../models/shelf_model.dart';

class ShelfRepository {
  final Dio _dio = Dio();
  final String baseUrl = "http://10.0.2.2:3000/api/shelf"; // Sesuaikan port backend-mu

  Future<List<ShelfModel>> getShelfItems() async {
    final response = await _dio.get(baseUrl);
    if (response.statusCode == 200 && response.data != null) {
      final List items = response.data['data'];
      return items.map((json) => ShelfModel.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> addToShelf(ShelfModel item) async {
    await _dio.post(baseUrl, data: item.toJson());
  }

  Future<void> removeFromShelf(String id) async {
    await _dio.delete('$baseUrl/$id');
  }
}