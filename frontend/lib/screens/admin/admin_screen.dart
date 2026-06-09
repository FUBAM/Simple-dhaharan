import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'admin_dashboard_screen.dart';
import 'admin_pending_screen.dart';
import '../profile/profile_screen.dart';
import '../../providers/recipe_provider.dart';
import '../recipe/my_recipe_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _currentIndex = 0;

  // Halaman khusus Admin
  final List<Widget> _screens = [
    const AdminDashboardScreen(),
    const AdminPendingScreen(),
    const MyRecipesScreen(),
    const ProfileScreen(), // Kita gunakan ulang layar profil yang sudah cantik
  ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<RecipeProvider>().loadPendingRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
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
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),

            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.pending_actions),

                  if (context.watch<RecipeProvider>().pendingRecipes.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,

                      child: Container(
                        padding: const EdgeInsets.all(4),

                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),

                        child: Text(
                          context
                              .watch<RecipeProvider>()
                              .pendingRecipes
                              .length
                              .toString(),

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              label: 'Persetujuan',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              label: 'Resepku',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
