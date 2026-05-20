import 'package:go_router/go_router.dart';

// Import semua halaman (screens) yang ada di aplikasimu
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/shelf_screen.dart'; // <-- INI YANG TADI HILANG

// Jika ada garis merah di dua baris bawah ini, 
// sesuaikan nama file-nya dengan yang ada di laptopmu ya!
import '../../presentation/screens/journal_screen.dart'; 
import '../../presentation/screens/login_screen.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    initialLocation: '/home', // Ubah ke '/login' jika aplikasi harus mulai dari login
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      // --- INI ADALAH JALUR MENUJU RAK VIRTUAL YANG BARU ---
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