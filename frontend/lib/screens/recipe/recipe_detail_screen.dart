import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../core/constants/api_constants.dart';
import 'create_recipe_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;
  final bool isMyRecipe;
  final bool isAdmin;

  const RecipeDetailScreen({
    super.key,
    required this.recipeId,
    this.isMyRecipe = false,
    this.isAdmin = false,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (widget.isAdmin) {
        await context.read<RecipeProvider>().loadAdminRecipeDetail(
          widget.recipeId,
        );
      } else if (widget.isMyRecipe) {
        await context.read<RecipeProvider>().loadMyRecipeDetail(
          widget.recipeId,
        );
      } else {
        await context.read<RecipeProvider>().loadRecipeDetail(widget.recipeId);
      }
    });
  }

  // Fungsi untuk menampilkan gambar full-screen (Zoom)
  void _showZoomableImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height * 0.8,
                width: double.infinity,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(ctx),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();
    final auth = context.watch<AuthProvider>();

    // 1. Tampilkan Loading hanya jika isLoading = true
    if (provider.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    // 2. Jika loading sudah selesai tapi data NULL (Error dari Backend)
    if (provider.selectedRecipe == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Kesalahan',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black87),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 80,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 16),
                Text(
                  provider.errorMessage ??
                      'Resep tidak ditemukan atau akses ditolak oleh server.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text(
                    'Kembali',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 3. Jika Data Berhasil Dimuat
    final recipe = provider.selectedRecipe!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          recipe.title,
          style: const TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          if (auth.user?.id == recipe.userId)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateRecipeScreen(recipeId: recipe.id),
                  ),
                );
              },
              icon: const Icon(Icons.edit_outlined, color: Colors.orange),
            ),
          if (widget.isAdmin)
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'private') {
                  await context.read<RecipeProvider>().privateRecipe(recipe.id);

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Recipe set to private')),
                  );

                  Navigator.pop(context, true);
                }
              },

              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'private',
                  child: Text('Set Private'),
                ),
              ],
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: [
          // Cover Image dengan Zoom
          if (recipe.coverImage != null)
            GestureDetector(
              onTap: () => _showZoomableImage(
                context,
                ApiConstants.baseUrl + recipe.coverImage!,
              ),
              child: Image.network(
                ApiConstants.baseUrl + recipe.coverImage!,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Warning Badges (Babi / Alkohol)
                if (recipe.containsPork || recipe.containsAlcohol)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        if (recipe.containsPork)
                          _buildWarningBadge('Mengandung Babi'),
                        if (recipe.containsPork && recipe.containsAlcohol)
                          const SizedBox(width: 8),
                        if (recipe.containsAlcohol)
                          _buildWarningBadge('Mengandung Alkohol'),
                      ],
                    ),
                  ),

                Text(
                  recipe.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  recipe.description ?? 'Tidak ada deskripsi',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Info Waktu & Porsi
                Row(
                  children: [
                    _buildInfoChip(
                      Icons.timer_outlined,
                      '${recipe.cookTime ?? 0} mnt',
                    ),
                    const SizedBox(width: 16),
                    _buildInfoChip(
                      Icons.people_outline,
                      '${recipe.servings ?? 0} porsi',
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Ingredients
                const Text(
                  'Bahan-bahan',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...recipe.ingredientGroups.map((group) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          group['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...group['ingredients'].map<Widget>((ingredient) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                size: 8,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${ingredient['quantity'] ?? ''} ${ingredient['unit'] ?? ''} ${ingredient['name']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                    ],
                  );
                }),

                const SizedBox(height: 24),

                // Steps
                const Text(
                  'Cara Memasak',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...recipe.steps.map((step) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          radius: 16,
                          child: Text(
                            '${step['step_number']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step['instruction'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if ((step['images'] as List).isNotEmpty)
                                SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: step['images'].length,
                                    itemBuilder: (context, imageIndex) {
                                      final imageUrl =
                                          ApiConstants.baseUrl +
                                          step['images'][imageIndex]['image_url'];
                                      return GestureDetector(
                                        onTap: () => _showZoomableImage(
                                          context,
                                          imageUrl,
                                        ), // Zoom Step Image
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            right: 12,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Image.network(
                                              imageUrl,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildWarningBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber_rounded, size: 14, color: Colors.red),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
