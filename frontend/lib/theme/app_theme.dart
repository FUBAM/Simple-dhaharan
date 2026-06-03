import 'package:flutter/material.dart';

class AppTheme {
  // Warna utama aplikasi (Oranye segar untuk makanan)
  static const Color primaryColor = Colors.orange;
  static const Color backgroundColor = Color(0xFFF8F9FA); // Abu-abu sangat muda

  static ThemeData get lightTheme {
    return ThemeData(
      colorSchemeSeed: primaryColor,
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Inter', // Boleh diganti jika ada font custom

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // cardTheme DIHAPUS agar tidak error CardThemeData, 
      // desain Card akan diatur langsung di file recipe_card.dart

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2), // Perbaikan disini
        ),
      ),
    );
  }
}