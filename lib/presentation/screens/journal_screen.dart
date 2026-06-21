import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                  // Memicu event Add Jurnal
                  context.read<JournalBloc>().add(JournalAddRequested(newJournal));
                } else {
                  // Memicu event Update Jurnal
                  context.read<JournalBloc>().add(JournalUpdateRequested(existingJournal.id, newJournal));
                }
                Navigator.pop(dialogContext); // Tutup dialog setelah tekan simpan
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