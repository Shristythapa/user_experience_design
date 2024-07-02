import 'package:momo_rating_app_frontend/core/model/momo/review_model.dart';

class UserRating {
  final String momoId;
  final String momoName;
  final String momoImage;
  final List<Review> ratings;

  UserRating({
    required this.momoId,
    required this.momoName,
    required this.momoImage,
    required this.ratings,
  });

  factory UserRating.fromJson(Map<String, dynamic> json) {
    List<dynamic> ratingsData = json['ratings'];
    List<Review> ratings = ratingsData
        .map((rating) => Review.fromJson(rating, json['momoId']))
        .toList();

    return UserRating(
      momoId: json['momoId'],
      momoName: json['momoName'],
      momoImage: json['momoImage'],
      ratings: ratings,
    );
  }
}
