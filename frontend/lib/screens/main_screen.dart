import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'home/home_screen.dart';
import 'recipe/my_recipe_screen.dart'; 
import 'login/login_screen.dart'; // Tambahkan import LoginScreen
import 'profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Halaman yang ada di navigasi bawah
  final List<Widget> _screens = [
    const HomeScreen(),
    const MyRecipesScreen(), 
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Ambil data AuthProvider untuk mengecek status login
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            // LOGIKA PROTEKSI GUEST DI SINI
            // Jika user klik tab 1 (ResepKu) atau 2 (Profil) tapi belum login
            if ((index == 1 || index == 2) && auth.user == null) {
              // Tampilkan pesan peringatan
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Silakan login terlebih dahulu untuk mengakses fitur ini.'),
                  backgroundColor: Colors.orange,
                ),
              );
              // Arahkan ke LoginScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
              return; // Hentikan fungsi agar tab tidak berubah
            }

            // Jika aman, ubah tab yang aktif
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'ResepKu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}