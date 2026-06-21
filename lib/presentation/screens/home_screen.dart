import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/book/book_bloc.dart';
import '../blocs/book/book_event.dart';
import '../blocs/book/book_state.dart';
import '../widgets/book_card.dart';

// JALUR IMPORT UNTUK RAK DAN JURNAL (Dipakai untuk pembersihan memori saat logout)
import '../blocs/shelf_bloc.dart';
import '../blocs/shelf_event.dart';
import '../../data/models/shelf_model.dart';
import '../blocs/journal/journal_bloc.dart'; 
import '../blocs/journal/journal_event.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          _scrollController.position.pixels > 0) {
        
        final currentState = context.read<BookBloc>().state;
        if (currentState is! BookLoading) {
          context.read<BookBloc>().add(BookLoadMoreRequested());
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _executeSearch(String query) {
    if (query.trim().isNotEmpty) {
      FocusManager.instance.primaryFocus?.unfocus(); 
      context.read<BookBloc>().add(BookSearchRequested(query.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eksplorasi Buku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.collections_bookmark),
            tooltip: 'Rak Virtual Saya',
            onPressed: () => context.push('/shelf'), 
          ),
          IconButton(
            icon: const Icon(Icons.library_books),
            tooltip: 'Rangkuman Buku Saya', 
            onPressed: () => context.push('/journal'), 
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar Akun',
            onPressed: () {
              // 1. "Sapu Bersih" data memori buku dari akun lama (INI YANG TADI MATI/DI-COMMENT)
              context.read<ShelfBloc>().add(ShelfClearDataRequested());
              context.read<JournalBloc>().add(JournalClearDataRequested());
              
              // 2. Hapus token keamanan
              context.read<AuthBloc>().add(AuthLogoutRequested());
              
              // 3. Pindah ke halaman login
              context.go('/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      labelText: 'Cari judul buku di Google Books...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    ),
                    onSubmitted: (value) => _executeSearch(value),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search, size: 28, color: Colors.white),
                    onPressed: () => _executeSearch(_searchController.text),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<BookBloc, BookState>(
              builder: (context, state) {
                if (state is BookLoading && context.read<BookBloc>().state is! BookLoaded) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BookLoaded) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.hasReachedMax ? state.books.length : state.books.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.books.length) {
                        return const Center(
                            child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: CircularProgressIndicator()));
                      }
                      final book = state.books[index];
                      return BookCard(
                        book: book,
                        onTap: () {
                          final shelfBook = ShelfModel(
                            id: '', 
                            bookId: book.id,
                            title: book.title,
                            authors: book.authors.isNotEmpty ? book.authors.first : 'Unknown Author', 
                            thumbnail: book.thumbnailUrl, 
                            previewLink: book.previewLink,
                            status: 'Ingin Dibaca', 
                          );

                          context.read<ShelfBloc>().add(ShelfAddRequested(shelfBook));

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Berhasil menyimpan "${book.title}" ke Rak Virtual!'),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is BookError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Gagal memuat: ${state.message}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }
                return const Center(child: Text('Ketikkan judul buku, lalu tekan tombol Cari.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}