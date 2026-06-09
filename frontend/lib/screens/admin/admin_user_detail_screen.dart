import 'package:flutter/material.dart';

import '../../services/recipe_service.dart';

import '../recipe/recipe_detail_screen.dart';

class AdminUserDetailScreen extends StatefulWidget {
  final int userId;

  const AdminUserDetailScreen({super.key, required this.userId});

  @override
  State<AdminUserDetailScreen> createState() => _AdminUserDetailScreenState();
}

class _AdminUserDetailScreenState extends State<AdminUserDetailScreen> {
  final service = RecipeService();

  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();

    loadDetail();
  }

  Future<void> loadDetail() async {
    final response = await service.getUserDetail(widget.userId);

    user = response.data;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(user!['name'])),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          Text(user!['email']),

          const SizedBox(height: 24),

          const Text('Daftar Resep'),

          const SizedBox(height: 12),

          ...(user!['recipes'] as List).map((recipe) {
            return Card(
              child: ListTile(
                title: Text(recipe['title']),

                subtitle: Text(recipe['status']),

                trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                onTap: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (_) => RecipeDetailScreen(
                        recipeId: recipe['id'],
                        isAdmin: true,
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
