import 'package:flutter/material.dart';

import '../models/recipe_model.dart';
import '../models/recipe_detail_model.dart';

import '../services/recipe_service.dart';
import '../models/my_recipe_model.dart';
import '../models/category_model.dart';

import '../services/upload_service.dart';

class RecipeProvider extends ChangeNotifier {
  final RecipeService _service = RecipeService();

  final UploadService _uploadService = UploadService();

  List<RecipeModel> recipes = [];
  List<MyRecipeModel> myRecipes = [];
  List<CategoryModel> categories = [];

  RecipeDetailModel? selectedRecipe;

  bool isLoading = false;
  String? coverImageUrl;

  Future<void> loadRecipes() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _service.getRecipes();

      print(response.data);

      recipes = (response.data as List)
          .map((e) => RecipeModel.fromJson(e))
          .toList();

      print("TOTAL RESEP: ${recipes.length}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadRecipeDetail(int recipeId) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _service.getRecipeDetail(recipeId);

      selectedRecipe = RecipeDetailModel.fromJson(response.data);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMyRecipes() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _service.getMyRecipes();

      myRecipes = (response.data as List)
          .map((e) => MyRecipeModel.fromJson(e))
          .toList();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCategories() async {
    final response = await _service.getCategories();

    categories = (response.data as List)
        .map((e) => CategoryModel.fromJson(e))
        .toList();

    notifyListeners();
  }

  Future<void> uploadCover(String imagePath) async {
    try {
      isLoading = true;
      notifyListeners();

      coverImageUrl = await _uploadService.uploadCover(imagePath);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String> uploadStepImage(String imagePath) async {
    return await _uploadService.uploadStepImage(imagePath);
  }

  Future<void> createRecipe(Map<String, dynamic> data) async {
    await _service.createRecipe(data);
  }

  Future<void> submitRecipe(int recipeId) async {
    await _service.submitRecipe(recipeId);

    await loadMyRecipes();
  }

  Future<void> updateRecipe(int recipeId, Map<String, dynamic> data) async {
    await _service.updateRecipe(recipeId, data);
  }
}
