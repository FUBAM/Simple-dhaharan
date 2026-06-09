import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipe_provider.dart';
import '../recipe/recipe_detail_screen.dart';

class AdminPendingScreen extends StatefulWidget {
  const AdminPendingScreen({super.key});

  @override
  State<AdminPendingScreen> createState() => _AdminPendingScreenState();
}

class _AdminPendingScreenState extends State<AdminPendingScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<RecipeProvider>().loadPendingRecipes();

      await context.read<RecipeProvider>().loadRejectedRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();
    final pendingRecipes = provider.pendingRecipes;

    return DefaultTabController(
      length: 2,

      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text(
            'Persetujuan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          backgroundColor: Colors.white,
          elevation: 0,

          bottom: const TabBar(
            tabs: [
              Tab(text: 'Menunggu'),

              Tab(text: 'Ditolak'),
            ],
          ),
        ),
        body: TabBarView(children: [buildPendingTab(), buildRejectedTab()]),
      ),
    );
  }

  Widget buildPendingTab() {
    final provider = context.watch<RecipeProvider>();

    final pendingRecipes = provider.pendingRecipes;

    return pendingRecipes.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 80,
                  color: Colors.green[200],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Semua resep sudah ditinjau!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pendingRecipes.length,
            itemBuilder: (context, index) {
              // Sesuai dengan AdminRecipeModel
              final recipe = pendingRecipes[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      // Kita panggil RecipeDetailScreen yang sudah cantik!
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecipeDetailScreen(
                            recipeId: recipe.id,
                            isAdmin: true,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.receipt_long_rounded,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  recipe.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    await provider.rejectRecipe(recipe.id);
                                    if (context.mounted)
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Resep Ditolak'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                  },
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    size: 18,
                                  ),
                                  label: const Text('Tolak'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    await provider.approveRecipe(recipe.id);
                                    if (context.mounted)
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Resep Disetujui'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                  },
                                  icon: const Icon(
                                    Icons.check_rounded,
                                    size: 18,
                                  ),
                                  label: const Text('Setujui'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }

  Widget buildRejectedTab() {
    final provider = context.watch<RecipeProvider>();

    final rejectedRecipes = provider.rejectedRecipes;

    if (rejectedRecipes.isEmpty) {
      return const Center(child: Text('Tidak ada resep ditolak'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),

      itemCount: rejectedRecipes.length,

      itemBuilder: (context, index) {
        final recipe = rejectedRecipes[index];

        return ListTile(
          title: Text(recipe.title),

          subtitle: const Text('Rejected'),

          onTap: () {
            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (_) =>
                    RecipeDetailScreen(recipeId: recipe.id, isAdmin: true),
              ),
            );
          },
        );
      },
    );
  }
}
