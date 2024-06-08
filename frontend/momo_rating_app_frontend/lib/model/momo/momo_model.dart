import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MoMoApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String userId;
  final String momoName;
  final String momoPrice;
  final String cookType;
  final String fillingType;
  final String location;

  MoMoApiModel(
      {this.id,
      required this.userId,
      required this.momoName,
      required this.momoPrice,
      required this.cookType,
      required this.fillingType,
      required this.location});
}
