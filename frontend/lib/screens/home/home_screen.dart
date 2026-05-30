import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

import '../login/login_screen.dart';

import '../../providers/recipe_provider.dart';

import '../recipe/recipe_detail_screen.dart';

import '../../core/constants/api_constants.dart';
import '../recipe/my_recipe_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  @override
  void initState() {

    super.initState();

    Future.microtask(() {

      context
          .read<RecipeProvider>()
          .loadRecipes();

    });
  }

    @override
  Widget build(
      BuildContext context) {

    final recipeProvider =
        context.watch<RecipeProvider>();

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Dhaharan',
        ),
        actions: [

          IconButton(
            onPressed: () async {

              await context
                  .read<AuthProvider>()
                  .logout();

              if (!context.mounted) {
                return;
              }

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const LoginScreen(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
                  IconButton(
          onPressed: () {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const MyRecipesScreen(),
              ),
            );

          },
          icon: const Icon(
            Icons.book,
          ),
        ),
        ],
      ),

      body: recipeProvider.isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : RefreshIndicator(
              onRefresh: () async {

                await recipeProvider
                    .loadRecipes();
              },

              child: ListView.builder(
                itemCount:
                    recipeProvider
                        .recipes
                        .length,

                itemBuilder:
                    (context, index) {

                  final recipe =
                      recipeProvider
                          .recipes[index];

                  return InkWell(
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              RecipeDetailScreen(
                            recipeId: recipe.id,
                          ),
                        ),
                      );

                    },
                    child: Card(
                      margin: const EdgeInsets.all(12),
                      child: ListTile(

                        leading: recipe.coverImage == null
                            ? const Icon(Icons.restaurant)
                            : Image.network(
                                ApiConstants.baseUrl +
                                    recipe.coverImage!,
                                width: 60,
                                fit: BoxFit.cover,
                              ),

                        title: Text(
                          recipe.title,
                        ),

                        subtitle: Text(
                          recipe.description ?? '',
                        ),
                      ),
                    ),
                  ); 
                },
              ),
            ),
    );
  }
}