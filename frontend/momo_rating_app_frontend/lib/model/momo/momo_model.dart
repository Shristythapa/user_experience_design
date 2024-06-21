import 'package:json_annotation/json_annotation.dart';
import 'package:momo_rating_app_frontend/model/momo/review_model.dart';

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
  final List<Review>? reviews;

  MoMoApiModel({
    this.id,
    this.momoImage,
    required this.userId,
    required this.momoName,
    required this.momoPrice,
    required this.cookType,
    required this.fillingType,
    required this.location,
    required this.shop,
    this.reviews,
  });

  // factory MoMoApiModel.fromJson(Map<String, dynamic> json) =>
  //     _$MoMoApiModelFromJson(json);
  // Map<String, dynamic> toJson() => _$MoMoApiModelToJson(this);
}
