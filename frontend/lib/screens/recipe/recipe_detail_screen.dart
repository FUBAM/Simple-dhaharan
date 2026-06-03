import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../core/constants/api_constants.dart';
import 'create_recipe_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;
  final bool isMyRecipe;

  const RecipeDetailScreen({
    super.key,
    required this.recipeId,
    this.isMyRecipe = false,
  });
  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (widget.isMyRecipe) {
        await context.read<RecipeProvider>().loadMyRecipeDetail(widget.recipeId);
      } else {
        await context.read<RecipeProvider>().loadRecipeDetail(widget.recipeId);
      }
    });
  }

  // FUNGSI BARU: Menampilkan gambar full screen yang bisa di-zoom
  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true, // Bisa digeser
              minScale: 0.5,
              maxScale: 4.0,    // Batas zoom maksimal
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();
    final auth = context.watch<AuthProvider>();

    if (provider.isLoading || provider.selectedRecipe == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final recipe = provider.selectedRecipe!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Gambar Header
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            backgroundColor: Colors.orange,
            iconTheme: const IconThemeData(color: Colors.white),
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
                  icon: const Icon(Icons.edit, color: Colors.white),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: recipe.coverImage != null
                  ? GestureDetector(
                      onTap: () => _showFullScreenImage(context, ApiConstants.baseUrl + recipe.coverImage!),
                      child: Image.network(
                        ApiConstants.baseUrl + recipe.coverImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.restaurant, size: 80, color: Colors.grey),
                    ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.2),
                  ),
                  const SizedBox(height: 16),
                  
                  // Info Ikon (Waktu, Porsi, Harga)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoItem(Icons.timer_outlined, '${recipe.cookTime ?? '-'} Menit'),
                      _buildInfoItem(Icons.people_outline, '${recipe.servings ?? '-'} Porsi'),
                      _buildInfoItem(Icons.monetization_on_outlined, 'Rp ${recipe.estimatedCost ?? '-'}'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // WARNING BADGE (Babi & Alkohol)
                  if (recipe.containsPork || recipe.containsAlcohol)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Mengandung ${recipe.containsPork ? 'Babi' : ''} ${recipe.containsPork && recipe.containsAlcohol ? '&' : ''} ${recipe.containsAlcohol ? 'Alkohol' : ''}',
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Deskripsi
                  if (recipe.description != null && recipe.description!.isNotEmpty) ...[
                    Text(recipe.description!, style: const TextStyle(color: Colors.black87, fontSize: 16, height: 1.5)),
                    const SizedBox(height: 24),
                  ],

                  // Bahan-bahan
                  const Text('Bahan-bahan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ...recipe.ingredientGroups.map((group) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (group['name'] != null && group['name'].isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              group['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16),
                            ),
                          ),
                        ...group['ingredients'].map<Widget>((ingredient) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8, left: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Icon(Icons.circle, size: 6, color: Colors.grey),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    ingredient['name'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                Text(
                                  '${ingredient['quantity'] ?? ''} ${ingredient['unit'] ?? ''}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),

                  const SizedBox(height: 16),

                  // Langkah-langkah
                  const Text('Langkah Memasak', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ...recipe.steps.map((step) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.orange,
                            child: Text(
                              '${step['step_number']}',
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step['instruction'],
                                  style: const TextStyle(height: 1.5, fontSize: 16),
                                ),
                                if ((step['images'] as List).isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    height: 120,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: step['images'].length,
                                      itemBuilder: (context, imageIndex) {
                                        final image = step['images'][imageIndex];
                                        final imageUrl = ApiConstants.baseUrl + image['image_url'];
                                        
                                        return Container(
                                          margin: const EdgeInsets.only(right: 12),
                                          child: GestureDetector(
                                            // PANGGIL FUNGSI ZOOM SAAT GAMBAR DITEKAN
                                            onTap: () => _showFullScreenImage(context, imageUrl),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.network(
                                                imageUrl,
                                                width: 120,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange, size: 28),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
      ],
    );
  }
}