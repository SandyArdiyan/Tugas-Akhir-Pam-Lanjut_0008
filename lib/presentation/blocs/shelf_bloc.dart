import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/shelf_repository.dart';
import 'shelf_event.dart';
import 'shelf_state.dart';

class ShelfBloc extends Bloc<ShelfEvent, ShelfState> {
  final ShelfRepository shelfRepository;

  ShelfBloc({required this.shelfRepository}) : super(ShelfInitial()) {
    on<ShelfLoadRequested>((event, emit) async {
      emit(ShelfLoading());
      try {
        final items = await shelfRepository.getShelfItems();
        emit(ShelfLoaded(List.from(items)));
      } catch (e) {
        emit(ShelfError(e.toString()));
      }
    });

    on<ShelfAddRequested>((event, emit) async {
      try {
        await shelfRepository.addToShelf(event.item);
        final items = await shelfRepository.getShelfItems();
        emit(ShelfLoaded(List.from(items)));
      } catch (e) {
        emit(ShelfError("Gagal menambahkan ke rak: Buku mungkin sudah ada."));
      }
    });

    on<ShelfRemoveRequested>((event, emit) async {
      try {
        await shelfRepository.removeFromShelf(event.id);
        final items = await shelfRepository.getShelfItems();
        emit(ShelfLoaded(List.from(items)));
      } catch (e) {
        emit(ShelfError("Gagal menghapus dari rak"));
      }
    });
  }
}