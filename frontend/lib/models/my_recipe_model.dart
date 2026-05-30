class MyRecipeModel {

  final int id;
  final String title;
  final String status;

  MyRecipeModel({
    required this.id,
    required this.title,
    required this.status,
  });

  factory MyRecipeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyRecipeModel(
      id: json['id'],
      title: json['title'],
      status: json['status'],
    );
  }
}