import 'package:momo_rating_app_frontend/main.dart';

class PreferenceModel {
  final String? id;
  final String userId;
  final List<CookType> cookType;
  // final List<Dite> fillingType;
  final List<FillingType> filling;

  PreferenceModel({
    this.id,
    required this.userId,
    required this.cookType,
    // required this.fillingType,
    required this.filling,
  });

  factory PreferenceModel.fromJson(Map<String, dynamic> json) {
    return PreferenceModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String,
      cookType: _parseEnumList<CookType>(json['cookType'], CookType.values),
      // fillingType: _parseEnumList<Dite>(json['fillingType'], Dite.values),
      filling: _parseEnumList<FillingType>(json['filling'], FillingType.values),
    );
  }

  static List<T> _parseEnumList<T>(List<dynamic> jsonList, List<T> enumValues) {
    return jsonList.map((value) {
      // Convert each value to string and trim any extra spaces
      final stringValue = value.toString().trim();
      // Find the corresponding enum value in enumValues
      return enumValues.firstWhere(
          (enumValue) => enumValue.toString() == stringValue,
          orElse: () =>
              throw FormatException('Unknown value $stringValue for enum $T'));
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'cookType': cookType.map((e) => e.toString()).toList(),
      // 'fillingType': fillingType.map((e) => e.toString()).toList(),
      'filling': filling.map((e) => e.toString()).toList(),
    };
  }
}
