import 'package:dio/dio.dart';

import 'api_service.dart';

class RecipeService {
  Future<Response> getRecipes() async {
    return await ApiService.dio.get('/recipes');
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

  // Future<Response> createRecipe(Map<String, dynamic> data) async {
  //   return await ApiService.dio.post('/recipes/', data: data);
  // }

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
}
