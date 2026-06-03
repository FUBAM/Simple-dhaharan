class AdminStatisticsModel {

  final int totalUsers;
  final int totalRecipes;
  final int totalPending;
  final int totalPublic;
  final int totalRejected;

  AdminStatisticsModel({
    required this.totalUsers,
    required this.totalRecipes,
    required this.totalPending,
    required this.totalPublic,
    required this.totalRejected,
  });

  factory AdminStatisticsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdminStatisticsModel(
      totalUsers:
          json['total_users'] ?? 0,

      totalRecipes:
          json['total_recipes'] ?? 0,

      totalPending:
          json['total_pending'] ?? 0,

      totalPublic:
          json['total_public'] ?? 0,

      totalRejected:
          json['total_rejected'] ?? 0,
    );
  }
}