class UserModel {
  int userId;
  String userName;
  int? playerRating;

  UserModel({
    required this.userId,
    required this.userName,
    this.playerRating,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      userName: json['userName'],
      playerRating:
          json.containsKey('playerRating') ? json['playerRating'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'playerRating': playerRating,
    };
  }
}
