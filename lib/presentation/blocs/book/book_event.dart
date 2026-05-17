import 'package:equatable/equatable.dart';

abstract class BookEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class BookSearchRequested extends BookEvent {
  final String query;
  BookSearchRequested(this.query);
  @override
  List<Object> get props => [query];
}

class BookLoadMoreRequested extends BookEvent {}