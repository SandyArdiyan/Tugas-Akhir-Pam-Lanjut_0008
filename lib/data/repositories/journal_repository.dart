import 'package:flutter/foundation.dart';
import '../../core/network/dio_client.dart';
import '../models/journal_model.dart';

class JournalRepository {
  final DioClient _dioClient;
  JournalRepository(this._dioClient);

  Future<List<JournalModel>> getJournals() async {
    try {
      final response = await _dioClient.dio.get('/journals');
      if (response.data != null && response.data['data'] is List) {
        final List data = response.data['data'];
        return data.map((json) => JournalModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("DEBUG REPO: $e");
      return [];
    }
  }

  Future<void> createJournal(JournalModel journal) async {
    await _dioClient.dio.post('/journals', data: journal.toJson());
  }

  Future<void> updateJournal(String id, JournalModel journal) async {
    await _dioClient.dio.put('/journals/$id', data: journal.toJson());
  }

  Future<void> deleteJournal(String id) async {
    await _dioClient.dio.delete('/journals/$id');
  }
}