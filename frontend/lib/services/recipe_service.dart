import 'package:dio/dio.dart';
import 'api_service.dart';

class RecipeService {
  Future<Response> getRecipes() async {
    return await ApiService.dio.get('/recipes/');
  }

  // FUNGSI BARU: Untuk pencarian dan filter
  Future<Response> searchRecipes({
    String? query,
    int? maxTime,
    int? servings,
    String? sort,
  }) async {
    final Map<String, dynamic> queryParams = {};

    if (query != null && query.isNotEmpty) queryParams['q'] = query;
    if (maxTime != null) queryParams['max_time'] = maxTime;
    if (servings != null) queryParams['servings'] = servings;
    if (sort != null) queryParams['sort'] = sort;

    return await ApiService.dio.get('/recipes/', queryParameters: queryParams);
  }

  Future<Response> getRecipeDetail(int recipeId) async {
    return await ApiService.dio.get('/recipes/$recipeId');
  }

  Future<Response> getMyRecipes() async {
    return await ApiService.dio.get('/recipes/my-recipes');
  }

  Future<Response> getCategories() async {
    return await ApiService.dio.get('/categories');
  }

  Future<Response> createRecipe(Map<String, dynamic> data) async {
    print("POST RECIPE");
    final response = await ApiService.dio.post('/recipes/', data: data);
    print(response.data);
    return response;
  }

  Future<Response> submitRecipe(int recipeId) async {
    return await ApiService.dio.put('/recipes/$recipeId/submit');
  }

  Future<Response> updateRecipe(int recipeId, Map<String, dynamic> data) async {
    return await ApiService.dio.put('/recipes/$recipeId', data: data);
  }

  Future<Response> getPendingRecipes() async {
    return await ApiService.dio.get('/recipes/admin/pending');
  }

  Future<Response> approveRecipe(int recipeId) async {
    return await ApiService.dio.put('/recipes/admin/$recipeId/approve');
  }

  Future<Response> rejectRecipe(int recipeId) async {
    return await ApiService.dio.put('/recipes/admin/$recipeId/reject');
  }

  Future<Response> deleteRecipe(int recipeId) async {
    return await ApiService.dio.delete('/recipes/$recipeId');
  }

  Future<Response> getAdminStatistics() async {
    return await ApiService.dio.get('/recipes/admin/statistics');
  }

  Future<Response> getMyRecipeDetail(int recipeId) async {
    return await ApiService.dio.get('/recipes/my-recipes/$recipeId');
  }

  Future<Response> getAdminRecipeDetail(int recipeId) async {
    return await ApiService.dio.get('/recipes/admin/detail/$recipeId');
  }

  Future<Response> getRejectedRecipes() async {
    return await ApiService.dio.get('/recipes/admin/rejected');
  }

  Future<Response> getUsers() async {
    return await ApiService.dio.get('/auth/admin/users');
  }

  Future<Response> getUserDetail(int userId) async {
    return await ApiService.dio.get('/auth/admin/users/$userId');
  }

  Future<Response> getAllRecipes() async {
    return await ApiService.dio.get('/recipes/admin/all');
  }

  Future<Response> privateRecipe(int recipeId) async {
    return await ApiService.dio.put('/recipes/admin/$recipeId/private');
  }
}
