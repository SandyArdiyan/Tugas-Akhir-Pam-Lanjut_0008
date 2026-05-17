import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/book_repository.dart';
import 'book_event.dart';
import 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository bookRepository;

  BookBloc({required this.bookRepository}) : super(BookInitial()) {
    
    on<BookSearchRequested>((event, emit) async {
      if (event.query.isEmpty) return;
      emit(BookLoading());
      try {
        final books = await bookRepository.searchBooks(event.query, startIndex: 0);
        emit(BookLoaded(
          books: books, 
          hasReachedMax: books.length < 10, 
          currentQuery: event.query,
        ));
      } catch (e) {
        emit(BookError(e.toString()));
      }
    });

    on<BookLoadMoreRequested>((event, emit) async {
      if (state is BookLoaded) {
        final currentState = state as BookLoaded;
        if (currentState.hasReachedMax) return; 

        try {
          final nextStartIndex = currentState.books.length;
          final moreBooks = await bookRepository.searchBooks(
            currentState.currentQuery, 
            startIndex: nextStartIndex
          );

          if (moreBooks.isEmpty) {
            emit(BookLoaded(
              books: currentState.books, 
              hasReachedMax: true, 
              currentQuery: currentState.currentQuery
            ));
          } else {
            emit(BookLoaded(
              books: currentState.books + moreBooks, 
              hasReachedMax: moreBooks.length < 10,
              currentQuery: currentState.currentQuery,
            ));
          }
        } catch (e) {
          emit(BookError(e.toString()));
        }
      }
    });
  }
}