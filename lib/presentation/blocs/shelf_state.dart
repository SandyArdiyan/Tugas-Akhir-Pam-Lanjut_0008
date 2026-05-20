import '../../data/models/shelf_model.dart';

abstract class ShelfState {}

class ShelfInitial extends ShelfState {}
class ShelfLoading extends ShelfState {}
class ShelfLoaded extends ShelfState {
  final List<ShelfModel> shelfItems;
  ShelfLoaded(this.shelfItems);
}
class ShelfError extends ShelfState {
  final String message;
  ShelfError(this.message);
}