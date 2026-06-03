import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/recipe_provider.dart';

// Tambahkan import MainScreen yang baru
import 'screens/main_screen.dart'; 

// SplashScreen kita nonaktifkan sementara agar langsung masuk ke MainScreen
// import 'screens/splash/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RecipeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Ubah dari SplashScreen() menjadi MainScreen()
      home: const MainScreen(),
    );
  }
}