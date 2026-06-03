import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipe_provider.dart';
import 'create_recipe_screen.dart';
import 'recipe_detail_screen.dart';

class MyRecipesScreen extends StatefulWidget {
  const MyRecipesScreen({super.key});

  @override
  State<MyRecipesScreen> createState() => _MyRecipesScreenState();
}

class _MyRecipesScreenState extends State<MyRecipesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RecipeProvider>().loadMyRecipes();
    });
  }

  // Fungsi helper untuk menentukan warna status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'public': return Colors.green;
      case 'pending': return Colors.orange;
      case 'rejected': return Colors.red;
      default: return Colors.grey; // Untuk private
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();
    
    return DefaultTabController(
      length: 4, // Jumlah tab
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ResepKu'),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.orange,
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'Private'),
              Tab(text: 'Pending'),
              Tab(text: 'Public'),
              Tab(text: 'Ditolak'),
            ],
          ),
        ),
        backgroundColor: const Color(0xFFF8F9FA),
        body: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildRecipeList(provider, 'private'),
                  _buildRecipeList(provider, 'pending'),
                  _buildRecipeList(provider, 'public'),
                  _buildRecipeList(provider, 'rejected'),
                ],
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateRecipeScreen()),
            );
          },
          backgroundColor: Colors.orange,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Buat Resep', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildRecipeList(RecipeProvider provider, String status) {
    // Filter resep berdasarkan status
    final filteredRecipes = provider.myRecipes
        .where((r) => r.status.toLowerCase() == status.toLowerCase())
        .toList();

    // Tampilan jika tab kosong
    if (filteredRecipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Belum ada resep dengan status ${status.toUpperCase()}.',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredRecipes.length,
      itemBuilder: (context, index) {
        final recipe = filteredRecipes[index];
        final statusColor = _getStatusColor(recipe.status);

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecipeDetailScreen(recipeId: recipe.id, isMyRecipe: true),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          recipe.title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          recipe.status.toUpperCase(),
                          style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (recipe.status.toLowerCase() == 'private' || recipe.status.toLowerCase() == 'rejected')
                        ElevatedButton.icon(
                          onPressed: () async {
                            await provider.submitRecipe(recipe.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Resep diajukan untuk direview Admin!'))
                              );
                            }
                          },
                          icon: const Icon(Icons.send, size: 16),
                          label: const Text('Submit Review'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            textStyle: const TextStyle(fontSize: 14),
                          ),
                        ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _confirmDelete(context, provider, recipe.id),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, RecipeProvider provider, int recipeId) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Hapus Resep'),
          content: const Text('Apakah Anda yakin ingin menghapus resep ini secara permanen?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await provider.deleteRecipe(recipeId);
    }
  }
}