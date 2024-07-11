import 'package:momo_rating_app_frontend/core/model/auth/user_model.dart';

class Review {
  final String? reviewId;
  final User userId;
  final String momoId;
  final String? shop;
  final String? location;
  final String? cookType;
  final String? fillingType;
  final String? image;
  final int overallRating;
  final int fillingAmount;
  final int sizeOfMomo;
  final int sauceVariety;
  final int aesthectic;
  final int spiceLevel;
  final int priceValue;
  final String review;

  Review({
    this.reviewId,
    this.shop,
    this.location,
    this.cookType,
    this.fillingType,
    this.image,
    required this.userId,
    required this.momoId,
    required this.overallRating,
    required this.fillingAmount,
    required this.sizeOfMomo,
    required this.sauceVariety,
    required this.aesthectic,
    required this.spiceLevel,
    required this.priceValue,
    required this.review,
  });

  factory Review.fromJson(Map<String, dynamic> json, String momoId) {
    return Review(
      reviewId: json['_id'],
      userId: User.fromJson(json['userId']),
      momoId: momoId,
      overallRating: json['overallRating'],
      fillingAmount: json['fillingAmount'],
      sizeOfMomo: json['sizeOfMomo'],
      sauceVariety: json['sauceVariety'],
      aesthectic: json['aesthectic'],
      spiceLevel: json['spiceLevel'],
      priceValue: json['priceValue'],
      review: json['review'],
    );
  }
}
