import 'package:flutter/material.dart';

import '../../models/admin_recipe_model.dart';
import '../../services/recipe_service.dart';
import '../recipe/recipe_detail_screen.dart';
// IMPORT INI YANG SEBELUMNYA HILANG:
import '../../core/constants/api_constants.dart';

class AdminAllRecipesScreen extends StatefulWidget {
  const AdminAllRecipesScreen({super.key});

  @override
  State<AdminAllRecipesScreen> createState() => _AdminAllRecipesScreenState();
}

class _AdminAllRecipesScreenState extends State<AdminAllRecipesScreen> {
  String selectedStatus = 'all';
  final service = RecipeService();

  List<AdminRecipeModel> recipes = [];
  List<AdminRecipeModel> filteredRecipes = [];

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  void applyFilter(String query) {
    filteredRecipes = recipes.where((recipe) {
      final matchTitle = recipe.title.toLowerCase().contains(
        query.toLowerCase(),
      );
      final matchStatus = selectedStatus == 'all'
          ? true
          : recipe.status == selectedStatus;
      return matchTitle && matchStatus;
    }).toList();

    setState(() {});
  }

  Future<void> loadRecipes() async {
    final response = await service
        .getAllRecipes(); // Pastikan getAllRecipes() ada di RecipeService
    recipes = (response.data as List)
        .map((e) => AdminRecipeModel.fromJson(e))
        .toList();
    filteredRecipes = recipes;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Semua Resep',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          // Bagian Pencarian & Filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari resep...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    onChanged: applyFilter,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedStatus,
                      icon: const Icon(Icons.filter_list, color: Colors.orange),
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('Semua')),
                        DropdownMenuItem(
                          value: 'public',
                          child: Text('Public'),
                        ),
                        DropdownMenuItem(
                          value: 'pending',
                          child: Text('Pending'),
                        ),
                        DropdownMenuItem(
                          value: 'private',
                          child: Text('Private'),
                        ),
                        DropdownMenuItem(
                          value: 'rejected',
                          child: Text('Rejected'),
                        ),
                      ],
                      onChanged: (value) {
                        selectedStatus = value!;
                        applyFilter(''); // Terapkan filter ulang
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Daftar Resep
          Expanded(
            child: filteredRecipes.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada resep yang sesuai.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];

                      // KATA 'return' INI SANGAT PENTING DAN SEBELUMNYA HILANG
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        shadowColor: Colors.black12,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: recipe.coverImage != null
                                ? Image.network(
                                    // Menggunakan ApiConstants sesuai standar aplikasi kita
                                    '${ApiConstants.baseUrl}${recipe.coverImage}',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, stack) =>
                                        Container(
                                          width: 60,
                                          height: 60,
                                          color: Colors.grey[200],
                                          child: const Icon(
                                            Icons.image_not_supported,
                                          ),
                                        ),
                                  )
                                : Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.restaurant,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                          title: Text(
                            recipe.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Status: ${recipe.status.toUpperCase()}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: recipe.status == 'public'
                                    ? Colors.green
                                    : (recipe.status == 'rejected'
                                          ? Colors.red
                                          : Colors.orange),
                              ),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RecipeDetailScreen(
                                  recipeId: recipe.id,
                                  isAdmin: true,
                                ),
                              ),
                            );

                            if (!mounted) return;

                            if (result == true) {
                              await loadRecipes();
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
