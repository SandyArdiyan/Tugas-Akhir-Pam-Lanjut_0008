import 'package:equatable/equatable.dart';
import '../../../data/models/journal_model.dart';

abstract class JournalEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class JournalLoadRequested extends JournalEvent {
  final String searchQuery;
  JournalLoadRequested({this.searchQuery = ''});
  @override
  List<Object> get props => [searchQuery];
}

class JournalAddRequested extends JournalEvent {
  final JournalModel journal;
  JournalAddRequested(this.journal);
  @override
  List<Object> get props => [journal];
}

class JournalUpdateRequested extends JournalEvent {
  final String id;
  final JournalModel journal;
  JournalUpdateRequested(this.id, this.journal);
  @override
  List<Object> get props => [id, journal];
}

class JournalDeleteRequested extends JournalEvent {
  final String id;
  JournalDeleteRequested(this.id);
  @override
  List<Object> get props => [id];
}