import 'package:equatable/equatable.dart';
import '../../../data/models/book_model.dart';

abstract class BookState extends Equatable {
  @override
  List<Object> get props => [];
}

class BookInitial extends BookState {}
class BookLoading extends BookState {}
class BookLoaded extends BookState {
  final List<BookModel> books;
  final bool hasReachedMax;
  final String currentQuery;
  
  BookLoaded({required this.books, required this.hasReachedMax, required this.currentQuery});
  
  @override
  List<Object> get props => [books, hasReachedMax, currentQuery];
}
class BookError extends BookState {
  final String message;
  BookError(this.message);
  @override
  List<Object> get props => [message];
}