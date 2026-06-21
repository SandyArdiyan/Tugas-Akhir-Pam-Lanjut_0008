import '../../core/network/dio_client.dart'; // <-- Panggil DioClient yang pintar
import '../models/shelf_model.dart';

class ShelfRepository {
  final DioClient dioClient; // <-- Menerima kurir dari main.dart

  // Constructor wajib diisi dengan DioClient
  ShelfRepository(this.dioClient);

  // Karena baseUrl (http://10.0.2.2:3000) sudah diatur di dalam DioClient,
  // di sini kita cukup menuliskan ujung jalurnya saja (endpoint).
  final String endpoint = '/api/shelf'; 

  Future<List<ShelfModel>> getShelfItems() async {
    // Gunakan dioClient.dio agar otomatis membawa Token Login
    final response = await dioClient.dio.get(endpoint);
    
    if (response.statusCode == 200 && response.data != null) {
      final List items = response.data['data'];
      return items.map((json) => ShelfModel.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> addToShelf(ShelfModel item) async {
    // Gunakan dioClient.dio untuk POST
    await dioClient.dio.post(endpoint, data: item.toJson());
  }

  Future<void> removeFromShelf(String id) async {
    // Gunakan dioClient.dio untuk DELETE
    await dioClient.dio.delete('$endpoint/$id');
  }
}