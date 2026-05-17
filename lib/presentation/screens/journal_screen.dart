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
    // READ: Load data jurnal saat halaman dibuka
    context.read<JournalBloc>().add(JournalLoadRequested());
  }

  void _showFormDialog(BuildContext context, {JournalModel? existingJournal}) {
    final titleController = TextEditingController(text: existingJournal?.bookTitle ?? '');
    final reviewController = TextEditingController(text: existingJournal?.review ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existingJournal == null ? 'Buat Jurnal Baru' : 'Edit Jurnal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(controller: titleController, label: 'Judul Buku'),
              const SizedBox(height: 10),
              CustomTextField(controller: reviewController, label: 'Review / Ringkasan', maxLines: 4),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                final newJournal = JournalModel(
                  id: existingJournal?.id ?? '', // ID kosong jika baru
                  bookId: 'custom', 
                  bookTitle: titleController.text,
                  review: reviewController.text,
                  rating: 5,
                );

                if (existingJournal == null) {
                  // CREATE
                  context.read<JournalBloc>().add(JournalAddRequested(newJournal));
                } else {
                  // UPDATE
                  context.read<JournalBloc>().add(JournalUpdateRequested(existingJournal.id, newJournal));
                }
                Navigator.pop(context);
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
      appBar: AppBar(title: const Text('Jurnal Saya')),
      body: BlocConsumer<JournalBloc, JournalState>(
        listener: (context, state) {
          if (state is JournalActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is JournalError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
          }
        },
        builder: (context, state) {
          if (state is JournalLoading) {
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
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(journal.bookTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(journal.review, maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // UPDATE Icon
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => _showFormDialog(context, existingJournal: journal),
                        ),
                        // DELETE Icon
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
          }
          return const Center(child: Text('Gagal memuat jurnal.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(context), // Tombol untuk CREATE
        child: const Icon(Icons.add),
      ),
    );
  }
}