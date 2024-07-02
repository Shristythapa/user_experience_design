import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/config/constants/api_endpoints.dart';
import 'package:momo_rating_app_frontend/core/error/failure.dart';
import 'package:momo_rating_app_frontend/core/network/http_service.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/core/model/preferences/preferences_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preferenceDataSourceProvider = Provider((ref) => PreferenceRepo(
    dio: ref.read(httpServiceProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider)));

class PreferenceRepo {
  final Dio dio;
  final UserSharedPrefs userSharedPrefs;

  PreferenceRepo({required this.dio, required this.userSharedPrefs});

  Future<Either<Failure, bool>> addPreferences(
      PreferenceModel preferenceModel) async {
    try {
      FormData formData = FormData.fromMap(preferenceModel.toJson());

      Response response = await dio.post(ApiEndpoints.addPreferences,
          data: formData,
          options: Options(headers: {'Content-Type': 'multipart/form-data'}));
      print(response);
      if (response.statusCode == 200) {
        return const Right(true);
      }

      return Left(Failure(
          error: response.data['message'],
          statusCode: response.statusCode.toString()));
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(
            Failure(error: e.response!.data['message'], statusCode: '404'));
      }
      return Left(Failure(error: e.error.toString(), statusCode: '200'));
    }
  }

  Future<Either<Failure, PreferenceModel>> getPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userJson = prefs.getString('user');
      if (userJson != null) {
        Map<String, dynamic> userData = jsonDecode(userJson);
        Response response =
            await dio.get(ApiEndpoints.viewPreferences + userData['_id']);
        print(response);
        if (response.statusCode == 200) {
          PreferenceModel model =
              PreferenceModel.fromJson(response.data['prefrence']);
          return Right(model);
        }
        return Left(Failure(
            error: response.data['message'],
            statusCode: response.statusCode.toString()));
      }
      return Left(
          Failure(error: "User Detail not found", statusCode: 404.toString()));
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(
            Failure(error: e.response!.data['message'], statusCode: '404'));
      }
      return Left(Failure(error: e.error.toString(), statusCode: '200'));
    }
  }
}
