class User {
  final String? userId;
  final String? userName;
  final String? profileImageUrl;

  User({this.userId, this.userName, this.profileImageUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['_id'],
      userName: json['userName'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
}
