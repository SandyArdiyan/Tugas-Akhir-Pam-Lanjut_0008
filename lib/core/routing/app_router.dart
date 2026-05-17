// lib/core/routing/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../data/storage/secure_storage_helper.dart';

// (Terkadang ada error merah di sini karena file screen belum dibuat, abaikan dulu)
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/journal_screen.dart';

class AppRouter {
  final SecureStorageHelper _storageHelper = SecureStorageHelper();

  late final GoRouter router = GoRouter(
    initialLocation: '/', // Mulai dari Splash Screen
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/journal', builder: (context, state) => const JournalScreen()),
    ],
    // ROUTE GUARD (Middleware Navigasi)
    redirect: (BuildContext context, GoRouterState state) async {
      final bool loggedIn = await _storageHelper.hasToken();
      final bool isLoggingIn = state.matchedLocation == '/login';
      final bool isSplash = state.matchedLocation == '/';

      // Jika belum login, dan tidak sedang di halaman login/splash -> tendang ke login
      if (!loggedIn && !isLoggingIn && !isSplash) return '/login';
      
      // Jika sudah login, tapi mencoba buka halaman login -> tendang ke home
      if (loggedIn && isLoggingIn) return '/home';
      
      return null; // Bebas akses
    },
  );
}