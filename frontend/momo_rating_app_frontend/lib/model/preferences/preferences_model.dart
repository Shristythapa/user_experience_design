import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PreferenceModel {
  @JsonKey(name: '_id')
  final String? id;
  final String userId;
  final int sizeOfMomo;
  final int fillings;
  final int aesthetics;
  final int sauceVarity;
  final int spiceLevel;

  PreferenceModel(
      {this.id,
      required this.userId,
      required this.sizeOfMomo,
      required this.fillings,
      required this.aesthetics,
      required this.sauceVarity,
      required this.spiceLevel});
}
