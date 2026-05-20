import '../../data/models/shelf_model.dart';

abstract class ShelfEvent {}

class ShelfLoadRequested extends ShelfEvent {}

class ShelfAddRequested extends ShelfEvent {
  final ShelfModel item;
  ShelfAddRequested(this.item);
}

class ShelfRemoveRequested extends ShelfEvent {
  final String id;
  ShelfRemoveRequested(this.id);
}