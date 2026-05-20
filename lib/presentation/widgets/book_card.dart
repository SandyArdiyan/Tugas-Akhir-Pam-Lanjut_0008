import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/book_model.dart';

class BookCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback onTap;

  const BookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
              child: book.thumbnailUrl.isNotEmpty
                  ? Image.network(
                      book.thumbnailUrl,
                      width: 100,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Icon(Icons.book, size: 100),
                    )
                  : Container(
                      width: 100,
                      height: 160,
                      color: Colors.grey[300],
                      child: const Icon(Icons.book, size: 50),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      book.authors.isNotEmpty ? book.authors.first : 'Unknown Author',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    // TOMBOL BACA PREVIEW (IN-APP BROWSER)
                    if (book.previewLink.isNotEmpty)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.open_in_browser, size: 16),
                        label: const Text('Baca Preview', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          minimumSize: const Size(0, 30),
                        ),
                        onPressed: () async {
                          // Pastikan skema tautan menggunakan https://
                          String finalLink = book.previewLink;
                          if (finalLink.startsWith('http://')) {
                            finalLink = finalLink.replaceFirst('http://', 'https://');
                          }

                          final Uri url = Uri.parse(finalLink);
                          try {
                            await launchUrl(
                              url,
                              mode: LaunchMode.inAppBrowserView, // Membuka browser internal aplikasi
                            );
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Gagal memuat halaman pratinjau buku.')),
                              );
                            }
                          }
                        },
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}