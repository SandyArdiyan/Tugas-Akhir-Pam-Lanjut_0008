class ShelfModel {
  final String id;
  final String bookId;
  final String title;
  final String authors;
  final String thumbnail;
  final String previewLink; // <-- TAMBAHAN
  final String status;

  ShelfModel({
    required this.id,
    required this.bookId,
    required this.title,
    required this.authors,
    required this.thumbnail,
    required this.previewLink, // <-- TAMBAHAN
    required this.status,
  });

  factory ShelfModel.fromJson(Map<String, dynamic> json) {
    return ShelfModel(
      id: json['_id'] ?? '',
      bookId: json['bookId'] ?? '',
      title: json['title'] ?? '',
      authors: json['authors'] ?? 'Unknown Author',
      thumbnail: json['thumbnail'] ?? '',
      previewLink: json['previewLink'] ?? '', // <-- TAMBAHAN
      status: json['status'] ?? 'Ingin Dibaca',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'title': title,
      'authors': authors,
      'thumbnail': thumbnail,
      'previewLink': previewLink, // <-- TAMBAHAN
      'status': status,
    };
  }
}