import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import Core & Storage
import 'core/routing/app_router.dart';
import 'core/utils/constants.dart';
import 'core/network/dio_client.dart';
import 'data/storage/secure_storage_helper.dart';

// Import Repositories
import 'data/repositories/auth_repository.dart';
import 'data/repositories/book_repository.dart';
import 'data/repositories/journal_repository.dart';
import 'data/repositories/shelf_repository.dart'; // <-- TAMBAHAN: Repository Rak

// Import Blocs & Events
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'presentation/blocs/book/book_bloc.dart';
import 'presentation/blocs/journal/journal_bloc.dart';
import 'presentation/blocs/shelf_bloc.dart'; // <-- TAMBAHAN: BLoC Rak (Sesuaikan foldernya jika kamu menaruhnya di dalam folder 'shelf/')

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Inisialisasi Storage Keamanan dan Middleware Jaringan
    final secureStorage = SecureStorageHelper();
    final dioClient = DioClient(secureStorage);

    return MultiRepositoryProvider(
      // 2. Daftarkan Semua Repository sebagai Jembatan ke API / Backend
      providers: [
        RepositoryProvider(create: (_) => AuthRepository(dioClient, secureStorage)),
        RepositoryProvider(create: (_) => BookRepository()),
        RepositoryProvider(create: (_) => JournalRepository(dioClient)),
        RepositoryProvider(create: (_) => ShelfRepository()), // <-- TAMBAHAN RAK
      ],
      // 3. Daftarkan Semua BLoC untuk Mengatur Logika Bisnis Aplikasi
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
              storageHelper: secureStorage,
            )..add(AuthCheckRequested()), // Cek token keamanan JWT secara otomatis saat start
          ),
          BlocProvider(
            create: (context) => BookBloc(
              bookRepository: context.read<BookRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => JournalBloc(
              journalRepository: context.read<JournalRepository>(),
            ),
          ),
          // <-- TAMBAHAN BLOC RAK
          BlocProvider(
            create: (context) => ShelfBloc(
              shelfRepository: context.read<ShelfRepository>(),
            ),
          ),
        ],
        child: const PustakaSiswaApp(),
      ),
    );
  }
}

class PustakaSiswaApp extends StatelessWidget {
  const PustakaSiswaApp({super.key});

  // Inisialisasi Router Navigasi
  static final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PustakaSiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      routerConfig: _appRouter.router, // Menggunakan go_router dengan Route Guard
    );
  }
}