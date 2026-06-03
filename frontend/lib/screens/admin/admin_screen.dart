import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/recipe_provider.dart';

import 'admin_recipe_detail_screen.dart';

import '../../providers/auth_provider.dart';

import '../login/login_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      print('LOAD ADMIN STATS');

      await context.read<RecipeProvider>().loadAdminStatistics();

      print('LOAD PENDING');

      await context.read<RecipeProvider>().loadPendingRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),

            onPressed: () async {
              final auth = context.read<AuthProvider>();

              await auth.logout();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,

                MaterialPageRoute(builder: (_) => const LoginScreen()),

                (route) => false,
              );
            },
          ),
        ],
      ),

      body: Consumer<RecipeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = provider.adminStatistics;

          if (stats == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: dashboardCard('Users', stats.totalUsers.toString()),
                  ),

                  Expanded(
                    child: dashboardCard(
                      'Recipes',
                      stats.totalRecipes.toString(),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: dashboardCard(
                      'Pending',
                      stats.totalPending.toString(),
                    ),
                  ),

                  Expanded(
                    child: dashboardCard(
                      'Public',
                      stats.totalPublic.toString(),
                    ),
                  ),
                ],
              ),

              dashboardCard('Rejected', stats.totalRejected.toString()),

              Expanded(
                child: ListView.builder(
                  itemCount: provider.pendingRecipes.length,

                  itemBuilder: (context, index) {
                    final recipe = provider.pendingRecipes[index];

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                AdminRecipeDetailScreen(recipeId: recipe.id),
                          ),
                        );
                      },

                      child: Card(
                        margin: const EdgeInsets.all(12),

                        child: Padding(
                          padding: const EdgeInsets.all(12),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                recipe.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text('Status: ${recipe.status}'),

                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await provider.approveRecipe(recipe.id);
                                        if (!context.mounted) return;

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Recipe approved'),
                                          ),
                                        );
                                      },

                                      child: const Text('Approve'),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await provider.rejectRecipe(recipe.id);
                                        if (!context.mounted) return;

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Recipe rejected'),
                                          ),
                                        );
                                      },

                                      child: const Text('Reject'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget dashboardCard(String title, String value) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(title),
        ],
      ),
    ),
  );
}
