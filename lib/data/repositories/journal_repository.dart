import '../../core/network/dio_client.dart';
import '../models/journal_model.dart';

class JournalRepository {
  final DioClient _dioClient;

  JournalRepository(this._dioClient);

  // READ & SEARCH (Mendapatkan daftar jurnal / mencari jurnal)
  Future<List<JournalModel>> getJournals({String searchQuery = ''}) async {
    try {
      final response = await _dioClient.dio.get('/journals', queryParameters: {
        'search': searchQuery, // Parameter search untuk query di backend
      });
      
      final List data = response.data['data'] ?? [];
      return data.map((json) => JournalModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil jurnal');
    }
  }

  // CREATE (Membuat jurnal baru)
  Future<void> createJournal(JournalModel journal) async {
    try {
      await _dioClient.dio.post('/journals', data: journal.toJson());
    } catch (e) {
      throw Exception('Gagal menyimpan jurnal');
    }
  }

  // UPDATE (Mengedit jurnal)
  Future<void> updateJournal(String id, JournalModel journal) async {
    try {
      await _dioClient.dio.put('/journals/$id', data: journal.toJson());
    } catch (e) {
      throw Exception('Gagal memperbarui jurnal');
    }
  }

  // DELETE (Menghapus jurnal)
  Future<void> deleteJournal(String id) async {
    try {
      await _dioClient.dio.delete('/journals/$id');
    } catch (e) {
      throw Exception('Gagal menghapus jurnal');
    }
  }
}