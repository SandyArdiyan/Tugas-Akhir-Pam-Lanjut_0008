class BookModel {
  final String id;
  final String title;
  final List<String> authors;
  final String description;
  final String thumbnailUrl;

  BookModel({
    required this.id,
    required this.title,
    required this.authors,
    required this.description,
    required this.thumbnailUrl,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};
    
    return BookModel(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'Judul Tidak Diketahui',
      authors: List<String>.from(volumeInfo['authors'] ?? []),
      description: volumeInfo['description'] ?? 'Tidak ada deskripsi.',
      thumbnailUrl: imageLinks['thumbnail'] ?? '', // URL cover buku
    );
  }
}