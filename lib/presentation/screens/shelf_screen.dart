import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../blocs/shelf_bloc.dart';
import '../blocs/shelf_event.dart';
import '../blocs/shelf_state.dart';

class ShelfScreen extends StatefulWidget {
  const ShelfScreen({super.key});

  @override
  State<ShelfScreen> createState() => _ShelfScreenState();
}

class _ShelfScreenState extends State<ShelfScreen> {
  @override
  void initState() {
    super.initState();
    // Ambil data rak terbaru dari database saat halaman terbuka
    context.read<ShelfBloc>().add(ShelfLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rak Buku Virtual'),
      ),
      body: BlocConsumer<ShelfBloc, ShelfState>(
        listener: (context, state) {
          if (state is ShelfError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is ShelfLoading || state is ShelfInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ShelfLoaded) {
            if (state.shelfItems.isEmpty) {
              return const Center(child: Text('Rak bukumumu masih kosong.'));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.55, // Proporsi pas untuk menampung cover, teks, dan tombol aksi
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: state.shelfItems.length,
              itemBuilder: (context, index) {
                final item = state.shelfItems[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                          child: item.thumbnail.isNotEmpty
                              ? Image.network(
                                  item.thumbnail,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.book, size: 50),
                                )
                              : const Icon(Icons.book, size: 50),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.authors,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      // BARIS TOMBOL AKSYON DI DALAM RAK
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (item.previewLink.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.open_in_browser, color: Colors.blue, size: 20),
                              tooltip: 'Baca di Web',
                              onPressed: () async {
                                String finalLink = item.previewLink;
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
                                      const SnackBar(content: Text('Gagal memuat halaman buku.')),
                                    );
                                  }
                                }
                              },
                            ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                            tooltip: 'Hapus dari Rak',
                            onPressed: () => context.read<ShelfBloc>().add(ShelfRemoveRequested(item.id)),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          } else if (state is ShelfError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}