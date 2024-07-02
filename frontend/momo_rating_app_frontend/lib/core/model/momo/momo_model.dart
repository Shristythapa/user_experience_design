import 'package:json_annotation/json_annotation.dart';
import 'package:momo_rating_app_frontend/core/model/momo/review_model.dart';

// part 'momo_model.g.dart'

// @JsonSerializable()
class MoMoApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? momoImage;
  final String userId;
  final String momoName;
  final String momoPrice;
  final String cookType;
  final String fillingType;
  final String location;
  final String shop;
  final bool? isSaved;
  final double? overallRating;
  final List<Review>? reviews;

  MoMoApiModel({
    this.id,
    this.momoImage,
    this.isSaved,
    this.overallRating,
    required this.userId,
    required this.momoName,
    required this.momoPrice,
    required this.cookType,
    required this.fillingType,
    required this.location,
    required this.shop,
    this.reviews,
  });

  factory MoMoApiModel.fromJson(Map<String, dynamic> json) {
    var reviewsFromJson = json['reviews'] as List;
    List<Review> reviewList = reviewsFromJson
        .map((reviewJson) => Review.fromJson(reviewJson, json['_id']))
        .toList();

    return MoMoApiModel(
      id: json['_id'],
      isSaved: json['isSaved'],
      momoImage: json['momoImage'],
      userId: json['userId'],
      momoName: json['momoName'],
      momoPrice: json['momoPrice'].toString(),
      cookType: json['cookType'],
      fillingType: json['fillingType'],
      location: json['location'],
      shop: json['shop'],
      overallRating: json['overallRating'].toDouble(),
      reviews: reviewList,
    );
  }
}
