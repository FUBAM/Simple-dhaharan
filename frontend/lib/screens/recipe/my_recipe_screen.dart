import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipe_provider.dart';
import '../../core/constants/api_constants.dart'; 
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
      length: 4, 
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ResepKu', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
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
            ? const Center(child: CircularProgressIndicator(color: Colors.orange))
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
    final filteredRecipes = provider.myRecipes
        .where((r) => r.status.toLowerCase() == status.toLowerCase())
        .toList();

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
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
      itemCount: filteredRecipes.length,
      itemBuilder: (context, index) {
        final recipe = filteredRecipes[index];
        final statusColor = _getStatusColor(recipe.status);

        return Card(
          margin: const EdgeInsets.only(bottom: 20),
          elevation: 3,
          shadowColor: Colors.black12,
          clipBehavior: Clip.antiAlias, 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecipeDetailScreen(recipeId: recipe.id, isMyRecipe: true),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. AREA GAMBAR & BADGE STATUS
                Stack(
                  children: [
                    recipe.coverImage != null
                        ? Image.network(
                            '${ApiConstants.baseUrl}${recipe.coverImage}',
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Container(
                              height: 160,
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image_rounded, size: 40, color: Colors.grey),
                            ),
                          )
                        : Container(
                            height: 160,
                            width: double.infinity,
                            color: Colors.orange.shade50,
                            child: const Icon(Icons.restaurant_menu_rounded, size: 50, color: Colors.orange),
                          ),
                    
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(radius: 4, backgroundColor: statusColor),
                            const SizedBox(width: 6),
                            Text(
                              recipe.status.toUpperCase(),
                              style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // 2. AREA INFO RESEP
                Padding(
                  // Padding bawah dikecilkan agar lebih rapat
                  padding: const EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          recipe.title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.3),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Ikon Informasi dan Tombol Hapus kini 1 baris
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, size: 18, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text('${recipe.cookTime ?? '-'} mnt', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500)),
                          
                          const SizedBox(width: 16),
                          
                          Icon(Icons.people_outline_rounded, size: 18, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text('${recipe.servings ?? '-'} porsi', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500)),
                          
                          const Spacer(), // Mendorong tombol hapus ke pojok kanan
                          
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                            tooltip: 'Hapus Resep',
                            onPressed: () => _confirmDelete(context, provider, recipe.id),
                          ),
                        ],
                      ),
                      
                      // 3. AREA TOMBOL AKSI (Muncul dinamis jika butuh Submit)
                      if (recipe.status.toLowerCase() == 'private' || recipe.status.toLowerCase() == 'rejected') ...[
                        const SizedBox(height: 4),
                        Divider(height: 1, color: Colors.grey.shade200),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () async {
                                await provider.submitRecipe(recipe.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Resep diajukan untuk direview Admin!'),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                    )
                                  );
                                }
                              },
                              icon: const Icon(Icons.send_rounded, size: 18),
                              label: const Text('Submit Review', style: TextStyle(fontWeight: FontWeight.bold)),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
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
          title: const Text('Hapus Resep', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Apakah Anda yakin ingin menghapus resep ini secara permanen? Tindakan ini tidak dapat dibatalkan.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Hapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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