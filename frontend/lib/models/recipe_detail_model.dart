class RecipeDetailModel {

  final int id;

  final int? categoryId;

  final String title;

  final String? description;

  final int? cookTime;

  final int? servings;

  final int? estimatedCost;

  final bool containsPork;

  final bool containsAlcohol;

  final String? coverImage;

  final String? status;

  final List ingredientGroups;

  final List steps;

  RecipeDetailModel({
    required this.id,
    this.categoryId,
    required this.title,
    this.description,
    this.cookTime,
    this.servings,
    this.estimatedCost,
    required this.containsPork,
    required this.containsAlcohol,
    this.coverImage,
    this.status,
    required this.ingredientGroups,
    required this.steps,
  });

  factory RecipeDetailModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return RecipeDetailModel(
      id: json['id'],

      categoryId:
          json['category_id'],

      title:
          json['title'] ?? '',

      description:
          json['description'],

      cookTime:
          json['cook_time'],

      servings:
          json['servings'],

      estimatedCost:
          json['estimated_cost'],

      containsPork:
          json['contains_pork']
              ?? false,

      containsAlcohol:
          json['contains_alcohol']
              ?? false,

      coverImage:
          json['cover_image'],

      status:
          json['status'],

      ingredientGroups:
          json['ingredient_groups']
              ?? [],

      steps:
          json['steps'] ?? [],
    );
  }
}