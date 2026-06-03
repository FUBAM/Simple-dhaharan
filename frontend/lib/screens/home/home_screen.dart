import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/recipe_provider.dart';
import '../recipe/recipe_detail_screen.dart';
import '../login/login_screen.dart'; // Import halaman login
import '../../widgets/recipe_card.dart';// Import filter bottom sheet
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RecipeProvider>().loadRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final recipeProvider = context.watch<RecipeProvider>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await recipeProvider.loadRecipes();
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting & Login Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user != null ? 'Halo, ${user.name}!' : 'Halo, Foodie!',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Mau masak apa hari ini?',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // Logika Tombol Login vs Avatar Profil
                          if (user != null)
                            CircleAvatar(
                              backgroundColor: Colors.orange.shade100,
                              child: const Icon(Icons.person, color: Colors.orange),
                            )
                          else
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.orange.shade50,
                                foregroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: const Icon(Icons.login, size: 18),
                              label: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Fake Search Bar
                      // Kotak Pencarian yang Bisa Diklik
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey.shade500),
                              const SizedBox(width: 12),
                              Text(
                                'Cari resep ayam, nasi goreng...',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Title "Resep Terbaru"
                      const Text(
                        'Resep Terbaru',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              recipeProvider.isLoading
                  ? const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final recipe = recipeProvider.recipes[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: RecipeCard(
                                recipe: recipe,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          RecipeDetailScreen(recipeId: recipe.id),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          childCount: recipeProvider.recipes.length,
                        ),
                      ),
                    ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        ),
      ),
    );
  }
}