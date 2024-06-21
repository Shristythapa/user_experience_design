// part 'review_model.g.dart';

// @JsonSerializable()
class Review {
  final String? reviewId;
  final String userId;
  final String momoId;
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

  // factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
  // Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
