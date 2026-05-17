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
        final journals = await journalRepository.getJournals(searchQuery: event.searchQuery);
        emit(JournalLoaded(journals));
      } catch (e) {
        emit(JournalError(e.toString()));
      }
    });

    on<JournalAddRequested>((event, emit) async {
      emit(JournalLoading());
      try {
        await journalRepository.createJournal(event.journal);
        emit(JournalActionSuccess("Jurnal berhasil ditambahkan!"));
        add(JournalLoadRequested()); 
      } catch (e) {
        emit(JournalError(e.toString()));
      }
    });

    on<JournalUpdateRequested>((event, emit) async {
      emit(JournalLoading());
      try {
        await journalRepository.updateJournal(event.id, event.journal);
        emit(JournalActionSuccess("Jurnal berhasil diperbarui!"));
        add(JournalLoadRequested()); 
      } catch (e) {
        emit(JournalError(e.toString()));
      }
    });

    on<JournalDeleteRequested>((event, emit) async {
      emit(JournalLoading());
      try {
        await journalRepository.deleteJournal(event.id);
        emit(JournalActionSuccess("Jurnal berhasil dihapus!"));
        add(JournalLoadRequested()); 
      } catch (e) {
        emit(JournalError(e.toString()));
      }
    });
  }
}