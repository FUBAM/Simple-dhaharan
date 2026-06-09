import 'package:flutter/material.dart';

import '../models/recipe_model.dart';
import '../models/recipe_detail_model.dart';
import '../services/recipe_service.dart';
import '../models/my_recipe_model.dart';
import '../models/category_model.dart';
import '../services/upload_service.dart';
import '../models/admin_recipe_model.dart';
import '../models/admin_statistics_model.dart';
import '../models/admin_user_model.dart';

class RecipeProvider extends ChangeNotifier {
  final RecipeService _service = RecipeService();
  final UploadService _uploadService = UploadService();

  List<RecipeModel> recipes = [];
  List<MyRecipeModel> myRecipes = [];
  List<CategoryModel> categories = [];
  List<AdminRecipeModel> pendingRecipes = [];
  List<AdminRecipeModel> rejectedRecipes = [];
  List<AdminUserModel> users = [];

  AdminStatisticsModel? adminStatistics;
  RecipeDetailModel? selectedRecipe;

  // STATE BARU UNTUK SEARCH
  List<RecipeModel> searchResults = [];
  bool isSearching = false;

  bool isLoading = false;
  String? coverImageUrl;
  String? errorMessage; // FUNGSI BARU: Menyimpan pesan error dari API

  Future<void> loadRecipes() async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await _service.getRecipes();
      recipes = (response.data as List)
          .map((e) => RecipeModel.fromJson(e))
          .toList();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadRecipeDetail(int recipeId) async {
    selectedRecipe = null;
    errorMessage = null; // Reset error
    try {
      isLoading = true;
      notifyListeners();
      final response = await _service.getRecipeDetail(recipeId);
      selectedRecipe = RecipeDetailModel.fromJson(response.data);
    } catch (e) {
      print('ERROR LOAD DETAIL: $e');
      errorMessage = e.toString(); // Tangkap error agar UI tahu
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMyRecipeDetail(int recipeId) async {
    selectedRecipe = null;
    errorMessage = null; // Reset error
    try {
      isLoading = true;
      notifyListeners();
      final response = await _service.getMyRecipeDetail(recipeId);
      selectedRecipe = RecipeDetailModel.fromJson(response.data);
    } catch (e) {
      print('ERROR LOAD MY DETAIL: $e');
      errorMessage = e.toString();
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
    await loadMyRecipes();
    await loadMyRecipeDetail(recipeId);
  }

  Future<void> loadPendingRecipes() async {
    try {
      final response = await _service.getPendingRecipes();
      pendingRecipes = (response.data as List)
          .map((e) => AdminRecipeModel.fromJson(e))
          .toList();
      notifyListeners();
    } catch (e) {
      print('ADMIN PENDING ERROR: $e');
    }
  }

  Future<void> refreshAdminDashboard() async {
    await loadPendingRecipes();
    await loadAdminStatistics();
  }

  Future<void> approveRecipe(int recipeId) async {
    await _service.approveRecipe(recipeId);
    await refreshAdminDashboard();
  }

  Future<void> rejectRecipe(int recipeId) async {
    await _service.rejectRecipe(recipeId);
    await refreshAdminDashboard();
  }

  Future<void> deleteRecipe(int recipeId) async {
    await _service.deleteRecipe(recipeId);
    await loadMyRecipes();
  }

  Future<void> loadAdminStatistics() async {
    final response = await _service.getAdminStatistics();
    adminStatistics = AdminStatisticsModel.fromJson(response.data);
    notifyListeners();
  }

  Future<void> searchRecipes({
    String? query,
    int? maxTime,
    int? servings,
    String? sort,
  }) async {
    try {
      isSearching = true;
      notifyListeners();

      final response = await _service.searchRecipes(
        query: query,
        maxTime: maxTime,
        servings: servings,
        sort: sort,
      );

      searchResults = (response.data as List)
          .map((e) => RecipeModel.fromJson(e))
          .toList();
    } catch (e) {
      print('SEARCH ERROR: $e');
      searchResults = [];
    } finally {
      isSearching = false;
      notifyListeners();
    }
  }

  Future<void> clearSearch() async {
    searchResults = [];
    notifyListeners();
  }

  Future<void> loadAdminRecipeDetail(int recipeId) async {
    selectedRecipe = null;
    errorMessage = null;

    try {
      isLoading = true;
      notifyListeners();

      final response = await _service.getAdminRecipeDetail(recipeId);

      selectedRecipe = RecipeDetailModel.fromJson(response.data);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadRejectedRecipes() async {
    final response = await _service.getRejectedRecipes();

    rejectedRecipes = (response.data as List)
        .map((e) => AdminRecipeModel.fromJson(e))
        .toList();

    notifyListeners();
  }

  Future<void> loadUsers() async {
    final response = await _service.getUsers();

    users = (response.data as List)
        .map((e) => AdminUserModel.fromJson(e))
        .toList();

    notifyListeners();
  }

  Future<void> privateRecipe(int recipeId) async {
    await _service.privateRecipe(recipeId);

    await loadPendingRecipes();

    await loadRejectedRecipes();

    notifyListeners();
  }
}
