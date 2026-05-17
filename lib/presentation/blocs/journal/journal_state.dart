import 'package:equatable/equatable.dart';
import '../../../data/models/journal_model.dart';

abstract class JournalState extends Equatable {
  @override
  List<Object> get props => [];
}

class JournalInitial extends JournalState {}
class JournalLoading extends JournalState {}
class JournalLoaded extends JournalState {
  final List<JournalModel> journals;
  JournalLoaded(this.journals);
  @override
  List<Object> get props => [journals];
}
class JournalActionSuccess extends JournalState {
  final String message;
  JournalActionSuccess(this.message);
  @override
  List<Object> get props => [message];
}
class JournalError extends JournalState {
  final String message;
  JournalError(this.message);
  @override
  List<Object> get props => [message];
}