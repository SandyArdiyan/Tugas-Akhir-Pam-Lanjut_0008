import 'package:go_router/go_router.dart';

// Import semua halaman (screens) yang ada di aplikasimu
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/shelf_screen.dart'; 
import '../../presentation/screens/journal_screen.dart'; 
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/splash_screen.dart'; // <-- 1. TAMBAHKAN IMPORT INI

class AppRouter {
  final GoRouter router = GoRouter(
    initialLocation: '/splash', // <-- 2. UBAH UTAMANYA KE /splash AGAR MUNCUL PERTAMA KALI
    routes: [
      // --- 3. JALUR UTAMA MENUJU SPLASH SCREEN ---
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/shelf',
        builder: (context, state) => const ShelfScreen(),
      ),
      GoRoute(
        path: '/journal',
        builder: (context, state) => const JournalScreen(),
      ),
    ],
  );
}