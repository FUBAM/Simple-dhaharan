import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/recipe_provider.dart';
import '../../widgets/recipe_card.dart';
import '../recipe/recipe_detail_screen.dart';
import '../../widgets/filter_bottom_sheet.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  
  // State filter saat ini
  int? _maxTime;
  int? _servings;
  String _sort = 'desc'; // Default terbaru

  @override
  void initState() {
    super.initState();
    // Bersihkan hasil pencarian sebelumnya saat masuk halaman
    Future.microtask(() => context.read<RecipeProvider>().clearSearch());
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    context.read<RecipeProvider>().searchRecipes(
      query: query.isNotEmpty ? query : null,
      maxTime: _maxTime,
      servings: _servings,
      sort: _sort,
    );
  }

  void _openFilter() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterBottomSheet(
        initialMaxTime: _maxTime,
        initialServings: _servings,
        initialSort: _sort,
      ),
    );

    if (result != null) {
      setState(() {
        _maxTime = result['maxTime'];
        _servings = result['servings'];
        _sort = result['sort'];
      });
      _performSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _performSearch(),
          decoration: InputDecoration(
            hintText: 'Cari resep (mis: Nasi Goreng)',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.orange),
            onPressed: _openFilter,
          ),
        ],
      ),
      body: provider.isSearching
          ? const Center(child: CircularProgressIndicator())
          : provider.searchResults.isEmpty && _searchController.text.isNotEmpty
              ? const Center(
                  child: Text('Resep tidak ditemukan', style: TextStyle(color: Colors.grey)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.searchResults.length,
                  itemBuilder: (context, index) {
                    final recipe = provider.searchResults[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: RecipeCard(
                        recipe: recipe,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecipeDetailScreen(recipeId: recipe.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}