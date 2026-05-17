class JournalModel {
  final String id;
  final String bookId;
  final String bookTitle;
  final String review;
  final int rating; // Misal 1 sampai 5

  JournalModel({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.review,
    required this.rating,
  });

  // Dari JSON API ke Object Dart (Read)
  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      id: json['id'].toString(),
      bookId: json['bookId'] ?? '',
      bookTitle: json['bookTitle'] ?? '',
      review: json['review'] ?? '',
      rating: json['rating'] ?? 0,
    );
  }

  // Dari Object Dart ke JSON API (Create/Update)
  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'bookTitle': bookTitle,
      'review': review,
      'rating': rating,
    };
  }
}