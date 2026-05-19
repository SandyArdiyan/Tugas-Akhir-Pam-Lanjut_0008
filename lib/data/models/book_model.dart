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
    
    // 1. Parsing List Authors yang jauh lebih aman dari error type-casting
    List<String> parsedAuthors = ['Penulis Tidak Diketahui'];
    if (volumeInfo['authors'] != null) {
      parsedAuthors = (volumeInfo['authors'] as List).map((e) => e.toString()).toList();
    }

    // 2. Cegah error HTTP Cleartext untuk load gambar cover buku
    String thumb = imageLinks['thumbnail'] ?? '';
    if (thumb.startsWith('http://')) {
      thumb = thumb.replaceFirst('http://', 'https://');
    }
    
    return BookModel(
      id: json['id']?.toString() ?? '',
      title: volumeInfo['title']?.toString() ?? 'Judul Tidak Diketahui',
      authors: parsedAuthors,
      description: volumeInfo['description']?.toString() ?? 'Tidak ada deskripsi.',
      thumbnailUrl: thumb,
    );
  }
}