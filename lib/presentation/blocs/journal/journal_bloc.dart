import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/journal_repository.dart';
import 'journal_event.dart';
import 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final JournalRepository journalRepository;

  JournalBloc({required this.journalRepository}) : super(JournalInitial()) {
    
    on<JournalLoadRequested>((event, emit) async {
      emit(JournalLoading());
      try {
        final journals = await journalRepository.getJournals();
        emit(JournalLoaded(List.from(journals))); // Gunakan List.from agar object baru
      } catch (e) {
        emit(JournalError(e.toString()));
      }
    });

    on<JournalAddRequested>((event, emit) async {
      try {
        await journalRepository.createJournal(event.journal);
        final journals = await journalRepository.getJournals();
        // Emit State Loading sebentar agar UI memaksa rebuild, baru masukkan data
        emit(JournalLoading()); 
        emit(JournalLoaded(List.from(journals)));
      } catch (e) {
        emit(JournalError("Gagal menyimpan jurnal"));
      }
    });

    on<JournalDeleteRequested>((event, emit) async {
      try {
        await journalRepository.deleteJournal(event.id);
        final journals = await journalRepository.getJournals();
        emit(JournalLoading()); 
        emit(JournalLoaded(List.from(journals)));
      } catch (e) {
        emit(JournalError("Gagal menghapus jurnal"));
      }
    });

    // ==========================================
    // TAMBAHAN: Instruksi Sapu Bersih Data Jurnal
    // ==========================================
    on<JournalClearDataRequested>((event, emit) {
      emit(JournalInitial());
    });
  }
}