class BookModel {
  final String id;
  final String title;
  final List<String> authors;
  final String description;
  final String thumbnailUrl;
  final String previewLink; // <-- TAMBAHAN

  BookModel({
    required this.id,
    required this.title,
    required this.authors,
    required this.description,
    required this.thumbnailUrl,
    required this.previewLink, // <-- TAMBAHAN
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};
    
    List<String> parsedAuthors = ['Penulis Tidak Diketahui'];
    if (volumeInfo['authors'] != null) {
      parsedAuthors = (volumeInfo['authors'] as List).map((e) => e.toString()).toList();
    }

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
      // Mengambil link baca dari API Google
      previewLink: volumeInfo['previewLink']?.toString() ?? '', 
    );
  }
}