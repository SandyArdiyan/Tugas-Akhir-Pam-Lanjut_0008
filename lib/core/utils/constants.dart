import 'package:flutter/material.dart';

class AppConstants {
  // Gunakan IP Ajaib Emulator agar langsung tembus ke Node.js di laptop
  static const String baseUrl = 'http://10.0.2.2:3000'; 
  
  // Google Books API (Free)
  static const String googleBooksApiUrl = 'https://www.googleapis.com/books/v1/volumes';
}

class AppColors {
  static const Color primary = Color(0xFF1E88E5); // Biru
  static const Color background = Color(0xFFF5F5F5); // Abu-abu terang
  static const Color textPrimary = Color(0xFF212121);
}