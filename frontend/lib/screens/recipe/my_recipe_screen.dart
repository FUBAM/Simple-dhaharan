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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Recipes')),

      body: ListView.builder(
        itemCount: provider.myRecipes.length,

        itemBuilder: (context, index) {
          final recipe = provider.myRecipes[index];

          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecipeDetailScreen(recipeId: recipe.id),
                ),
              );
            },

            title: Text(recipe.title),
            subtitle: Text(recipe.status),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Chip(label: Text(recipe.status)),
                if (recipe.status == 'private')
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await context.read<RecipeProvider>().submitRecipe(
                          recipe.id,
                        );
                      },
                      child: const Text('Submit'),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateRecipeScreen()),
          );
        },

        child: const Icon(Icons.add),
      ),
    );
  }
}
