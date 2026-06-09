class AdminRecipeModel {

  final int id;
  final String title;
  final String status;
  final int userId;
  final String? coverImage;

  AdminRecipeModel({
    required this.id,
    required this.title,
    required this.status,
    required this.userId,
    required this.coverImage,
  });

  factory AdminRecipeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdminRecipeModel(
      id: json['id'],
      title: json['title'],
      status: json['status'],
      userId: json['user_id'],
      coverImage: json['cover_image'],
    );
  }
}