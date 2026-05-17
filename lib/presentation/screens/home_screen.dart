import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/book/book_bloc.dart';
import '../blocs/book/book_event.dart';
import '../blocs/book/book_state.dart';
import '../widgets/book_card.dart';
import '../widgets/custom_textfield.dart';

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
    // Deteksi scroll ke bawah untuk Pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        context.read<BookBloc>().add(BookLoadMoreRequested());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eksplorasi Buku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.library_books),
            tooltip: 'Jurnal Saya',
            onPressed: () => context.push('/journal'), // Ke halaman CRUDS
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
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
                  child: CustomTextField(
                    controller: _searchController,
                    label: 'Cari judul buku di Google Books...',
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.search, size: 30, color: Colors.blue),
                  onPressed: () {
                    context.read<BookBloc>().add(BookSearchRequested(_searchController.text));
                  },
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
                        return const Center(child: Padding(padding: EdgeInsets.all(15.0), child: CircularProgressIndicator()));
                      }
                      final book = state.books[index];
                      return BookCard(
                        book: book,
                        onTap: () {
                          // Aksi jika buku di klik (misal mau langsung buat jurnal)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Pilih ${book.title} untuk ditambahkan ke jurnal? Buka menu Jurnal Saya!')),
                          );
                        },
                      );
                    },
                  );
                } else if (state is BookError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text('Ketikkan judul buku untuk memulai pencarian.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}