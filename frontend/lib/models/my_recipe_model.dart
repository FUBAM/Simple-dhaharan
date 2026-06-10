class MyRecipeModel {

  final int id;
  final String title;
  final String status;
  final String? coverImage;

  final int? cookTime;

  final int? servings;
  MyRecipeModel({
    required this.id,
    required this.title,
    required this.status,
    required this.coverImage,
    this.cookTime,
    this.servings,

  });

  factory MyRecipeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyRecipeModel(
      id: json['id'],
      title: json['title'],
      status: json['status'],
      coverImage: json['cover_image'],
      cookTime: json['cook_time'],
      servings: json['servings'],
    );
  }
}