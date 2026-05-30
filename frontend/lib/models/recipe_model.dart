class RecipeModel {

  final int id;

  final String title;

  final String? description;

  final String? coverImage;

  final int? cookTime;

  final int? servings;

  RecipeModel({
    required this.id,
    required this.title,
    this.description,
    this.coverImage,
    this.cookTime,
    this.servings,
  });

  factory RecipeModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return RecipeModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'],
      coverImage: json['cover_image'],
      cookTime: json['cook_time'],
      servings: json['servings'],
    );
  }
}