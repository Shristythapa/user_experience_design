
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

 factory Review.fromJson(Map<String, dynamic> json, String momoId) {
    return Review(
      reviewId: json['_id'],
      userId: json['userId'],
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
