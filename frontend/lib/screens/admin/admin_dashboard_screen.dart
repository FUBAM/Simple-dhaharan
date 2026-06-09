import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipe_provider.dart';
// TODO: Jangan lupa import halaman AdminUsersScreen jika file-nya ada di folder yang sama
import 'admin_users_screen.dart';
import 'admin_all_recipes_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RecipeProvider>().loadAdminStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();
    final stats = provider.adminStatistics;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: stats == null
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : RefreshIndicator(
              onRefresh: () async {
                await provider.loadAdminStatistics();
              },
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Ringkasan Data',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // KARTU TOTAL USER: Ditambahkan aksi onTap sesuai instruksi
                      _buildStatCard(
                        'Total User',
                        '${stats.totalUsers}',
                        Icons.people_alt_rounded,
                        Colors.blue,
                        onTap: () {
                          // Pastikan file AdminUsersScreen sudah Anda buat!
                          // Jika belum, beri komentar pada dua baris Navigator di bawah ini agar tidak error
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminUsersScreen(),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Menuju Halaman Admin Users...'),
                            ),
                          );
                        },
                      ),

                      // KARTU LAINNYA (Tanpa aksi klik)
                      _buildStatCard(
                        'Semua Resep',
                        '${stats.totalRecipes}',
                        Icons.restaurant_menu_rounded,
                        Colors.orange,
                        onTap: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) => const AdminAllRecipesScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  // FUNGSI BUILDER: Ditambahkan parameter {VoidCallback? onTap}
  Widget _buildStatCard(
    String title,
    String count,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    // Dibungkus dengan InkWell (atau GestureDetector) agar bisa diklik
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const Spacer(),
            Text(
              count,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
