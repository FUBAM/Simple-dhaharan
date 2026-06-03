import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipe_provider.dart';
import '../../core/constants/api_constants.dart';
import '../recipe/create_recipe_screen.dart';

class AdminRecipeDetailScreen extends StatefulWidget {
  final int recipeId;

  const AdminRecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<AdminRecipeDetailScreen> createState() =>
      _AdminRecipeDetailScreenState();
}

class _AdminRecipeDetailScreenState extends State<AdminRecipeDetailScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<RecipeProvider>().loadRecipeDetail(widget.recipeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();

    print(provider.adminStatistics);

    if (provider.isLoading || provider.selectedRecipe == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final recipe = provider.selectedRecipe!;

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateRecipeScreen(recipeId: recipe.id),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          if (recipe.coverImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),

              child: Image.network(
                ApiConstants.baseUrl + recipe.coverImage!,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

          const SizedBox(height: 16),
          Text(
            recipe.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(recipe.description ?? ''),

          const SizedBox(height: 24),

          const Text(
            'Ingredients',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          ...recipe.ingredientGroups.map((group) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                ...group['ingredients'].map<Widget>((ingredient) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      '• ${ingredient['quantity'] ?? ''} ${ingredient['unit'] ?? ''} ${ingredient['name']}',
                    ),
                  );
                }),

                const SizedBox(height: 12),
              ],
            );
          }),

          const SizedBox(height: 24),

          const Text(
            'Steps',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          ...recipe.steps.map((step) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step ${step['step_number']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    Text(step['instruction']),
                    const SizedBox(height: 12),
                    if ((step['images'] as List).isNotEmpty)
                      SizedBox(
                        height: 100,

                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,

                          itemCount: step['images'].length,

                          itemBuilder: (context, imageIndex) {
                            final image = step['images'][imageIndex];

                            return Container(
                              margin: const EdgeInsets.only(right: 8),

                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),

                                child: Image.network(
                                  ApiConstants.baseUrl + image['image_url'],
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
          Consumer<RecipeProvider>(
            builder: (context, provider, child) {
              final recipe = provider.selectedRecipe;

              if (recipe == null) {
                return const SizedBox();
              }

              if (recipe.status != 'pending') {
                return const SizedBox();
              }

              return Padding(
                padding: const EdgeInsets.all(16),

                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await provider.approveRecipe(recipe.id);

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },

                        child: const Text('Approve'),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await provider.rejectRecipe(recipe.id);

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },

                        child: const Text('Reject'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
