import 'package:flutter/material.dart';
import '../../data/models/book_model.dart';

class BookCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback onTap;

  const BookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: book.thumbnailUrl.isNotEmpty
            ? Image.network(book.thumbnailUrl, width: 50, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.book, size: 50))
            : const Icon(Icons.book, size: 50),
        title: Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(book.authors.join(', '), maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.add_circle_outline, color: Colors.blue),
        onTap: onTap,
      ),
    );
  }
}