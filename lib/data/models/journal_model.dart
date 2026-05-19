class JournalModel {
  final String id;
  final String bookId;
  final String bookTitle;
  final String review;
  final int rating;

  JournalModel({
    this.id = '',
    required this.bookId,
    required this.bookTitle,
    required this.review,
    this.rating = 5,
  });

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      bookId: (json['bookId'] ?? '').toString(),
      bookTitle: (json['bookTitle'] ?? 'Tanpa Judul').toString(),
      review: (json['review'] ?? '').toString(),
      rating: (json['rating'] != null) ? int.tryParse(json['rating'].toString()) ?? 5 : 5,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'bookId': bookId,
      'bookTitle': bookTitle,
      'review': review,
      'rating': rating,
    };
    if (id.trim().isNotEmpty) {
      data['id'] = id;
    }
    return data;
  }
}