import 'package:flutter/material.dart';
import '../../services/recipe_service.dart';
import 'admin_user_detail_screen.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() =>
      _AdminUsersScreenState();
}

class _AdminUsersScreenState
    extends State<AdminUsersScreen> {

  final service = RecipeService();

  List users = [];

  List filteredUsers = [];

  @override
  void initState() {
    super.initState();

    loadUsers();
  }

  Future<void> loadUsers() async {

    final response =
        await service.getUsers();

    users = response.data;

    filteredUsers = users;

    setState(() {});
  }

  void searchUser(String query) {

    filteredUsers = users.where((user) {

      return user['name']
          .toString()
          .toLowerCase()
          .contains(
            query.toLowerCase(),
          );

    }).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text('Semua User'),
      ),

      body: Column(

        children: [

          Padding(
            padding:
                const EdgeInsets.all(12),

            child: TextField(

              decoration:
                  const InputDecoration(
                hintText:
                    'Cari user...',
              ),

              onChanged:
                  searchUser,
            ),
          ),

          Expanded(
            child: ListView.builder(

              itemCount:
                  filteredUsers.length,

              itemBuilder:
                  (context, index) {

                final user =
                    filteredUsers[index];

                return ListTile(

                  title:
                      Text(
                    user['name'],
                  ),

                  subtitle:
                      Text(
                    user['email'],
                  ),

                  trailing:
                      Text(
                    user['role'],
                  ),

                  onTap: () {

                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                            AdminUserDetailScreen(
                          userId:
                              user['id'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}