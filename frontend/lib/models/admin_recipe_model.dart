class AdminRecipeModel {

  final int id;
  final String title;
  final String status;
  final int userId;

  AdminRecipeModel({
    required this.id,
    required this.title,
    required this.status,
    required this.userId,
  });

  factory AdminRecipeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdminRecipeModel(
      id: json['id'],
      title: json['title'],
      status: json['status'],
      userId: json['user_id'],
    );
  }
}