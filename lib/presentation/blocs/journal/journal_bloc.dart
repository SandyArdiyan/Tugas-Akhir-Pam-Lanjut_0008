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
        emit(JournalLoaded(journals));
      } catch (e) {
        emit(JournalError(e.toString()));
      }
    });

    on<JournalAddRequested>((event, emit) async {
      try {
        await journalRepository.createJournal(event.journal);
        final journals = await journalRepository.getJournals();
        emit(JournalLoaded(journals));
      } catch (e) {
        emit(JournalError("Gagal menyimpan jurnal"));
      }
    });

    on<JournalDeleteRequested>((event, emit) async {
      try {
        await journalRepository.deleteJournal(event.id);
        final journals = await journalRepository.getJournals();
        emit(JournalLoaded(journals));
      } catch (e) {
        emit(JournalError("Gagal menghapus jurnal"));
      }
    });
  }
}