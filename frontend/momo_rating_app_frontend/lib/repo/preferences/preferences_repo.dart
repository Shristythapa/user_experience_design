import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:momo_rating_app_frontend/config/constants/api_endpoints.dart';
import 'package:momo_rating_app_frontend/core/error/failure.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/model/preferences/preferences_model.dart';

class PreferenceRepo {
  final Dio dio;
  final UserSharedPrefs userSharedPrefs;

  PreferenceRepo({required this.dio, required this.userSharedPrefs});

  Future<Either<Failure, bool>> addPreferences(
      PreferenceModel preferenceModel) async {
    try {
      FormData formData = FormData.fromMap({
        'userId': preferenceModel.userId,
        'sizeOfMomo': preferenceModel.sizeOfMomo,
        'fillings': preferenceModel.fillings,
        'aesthetics': preferenceModel.aesthetics,
        'sauceVarity': preferenceModel.sauceVarity,
        'spiceLevel': preferenceModel.spiceLevel
      });

      Response response = await dio.post(ApiEndpoints.addMomo,
          data: formData,
          options: Options(headers: {'Content-Type': 'multipart/form-data'}));
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
}
