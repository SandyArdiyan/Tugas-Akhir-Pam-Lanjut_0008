import 'dart:io'; // <-- TAMBAHAN: Untuk mengelola File
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart'; // <-- TAMBAHAN: Untuk mencari folder penyimpanan lokal

import '../blocs/journal/journal_bloc.dart';
import '../blocs/journal/journal_event.dart';
import '../blocs/journal/journal_state.dart';
import '../../data/models/journal_model.dart';
import '../widgets/custom_textfield.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  @override
  void initState() {
    super.initState();
    context.read<JournalBloc>().add(JournalLoadRequested());
  }

  // =================================================================
  // FITUR BARU: Fungsi untuk Export (Memenuhi Syarat File Storage)
  // =================================================================
  Future<void> _exportJournalToTxt(BuildContext context, String bookTitle, String review, int rating) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final cleanTitle = bookTitle.replaceAll(' ', '_').toLowerCase();
      final file = File('${directory.path}/ulasan_$cleanTitle.txt');

      final content = '''
================================
PUSTAKASISWA - JURNAL LITERASI
================================
Judul Buku : $bookTitle
Rating     : $rating/5 Bintang
Tanggal    : ${DateTime.now().toString().substring(0, 10)}

Ulasan:
$review
================================
''';

      await file.writeAsString(content);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil diekspor ke: ${file.path}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengekspor file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showFormDialog(BuildContext context, {JournalModel? existingJournal}) {
    final titleController = TextEditingController(text: existingJournal?.bookTitle ?? '');
    final reviewController = TextEditingController(text: existingJournal?.review ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(existingJournal == null ? 'Buat Rangkuman Buku' : 'Edit Buku'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(controller: titleController, label: 'Judul Buku'),
              const SizedBox(height: 10),
              CustomTextField(controller: reviewController, label: 'Review / Ringkasan', maxLines: 4),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext), 
              child: const Text('Batal', style: TextStyle(color: Colors.grey))
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty || reviewController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Isi semua kolom!'), backgroundColor: Colors.red)
                  );
                  return;
                }

                final newJournal = JournalModel(
                  id: existingJournal?.id ?? '', 
                  bookId: existingJournal?.bookId ?? 'custom_${DateTime.now().millisecondsSinceEpoch}', 
                  bookTitle: titleController.text.trim(),
                  review: reviewController.text.trim(),
                  rating: 5,
                );

                if (existingJournal == null) {
                  context.read<JournalBloc>().add(JournalAddRequested(newJournal));
                } else {
                  context.read<JournalBloc>().add(JournalUpdateRequested(existingJournal.id, newJournal));
                }
                Navigator.pop(dialogContext); 
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rangkuman Buku Saya')),
      body: BlocConsumer<JournalBloc, JournalState>(
        listener: (context, state) {
          if (state is JournalActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.green));
          } else if (state is JournalError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
          }
        },
        builder: (context, state) {
          if (state is JournalLoading || state is JournalInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is JournalLoaded) {
            if (state.journals.isEmpty) {
              return const Center(child: Text('Belum ada jurnal. Yuk mulai membaca!'));
            }
            return ListView.builder(
              itemCount: state.journals.length,
              itemBuilder: (context, index) {
                final journal = state.journals[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(journal.bookTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(journal.review, maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ==========================================
                        // TOMBOL BARU: Download / Export Jurnal
                        // ==========================================
                        IconButton(
                          icon: const Icon(Icons.download, color: Colors.blue),
                          tooltip: 'Export ke TXT',
                          onPressed: () => _exportJournalToTxt(
                            context,
                            journal.bookTitle,
                            journal.review,
                            journal.rating,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => _showFormDialog(context, existingJournal: journal),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => context.read<JournalBloc>().add(JournalDeleteRequested(journal.id)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is JournalError) {
            return Center(
              child: Text('Terjadi Kesalahan:\n${state.message}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}