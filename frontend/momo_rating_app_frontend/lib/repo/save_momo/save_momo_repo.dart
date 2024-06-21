import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/config/constants/api_endpoints.dart';
import 'package:momo_rating_app_frontend/core/error/failure.dart';
import 'package:momo_rating_app_frontend/core/network/http_service.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/model/momo/momo_model.dart';

final saveMomoRepoProvider = Provider((ref) => SaveMomoRepo(
    userSharedPrefs: ref.read(userSharedPrefsProvider),
    dio: ref.read(httpServiceProvider)));

class SaveMomoRepo {
  final Dio dio;
  final UserSharedPrefs userSharedPrefs;

  SaveMomoRepo({required this.userSharedPrefs, required this.dio});

  Future<Either<Failure, bool>> saveMoMo({
    required String userId,
    required String momoId,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'userId': userId,
        'momoId': momoId,
      });

      Response response = await dio.post(ApiEndpoints.saveMomo,
          data: formData,
          options: Options(headers: {'Content-Type': 'application/json'}));

      if (response.statusCode == 200) {
        return const Right(true);
      }

      return Left(Failure(
          error: response.data['message'],
          statusCode: response.statusCode.toString()));
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(Failure(error: "Api Error", statusCode: "404"));
      }
      return Left(Failure(error: e.error.toString(), statusCode: '0'));
    }
  }
  // Future<Either<Failure, List<MoMoApiModel>>> getMomosByUserId(
  //     String userId) async {
  //   try {
  //     final response =
  //         await dio.get('${ApiEndpoints.getMomosByUserId}/$userId');
  //     if (response.statusCode == 200) {
  //       List<MoMoApiModel> momos = (response.data as List)
  //           .map((momo) => MoMoApiModel.fromJson(momo))
  //           .toList();
  //       return Right(momos);
  //     } else {
  //       return Left(Failure(
  //           error: response.data['message'],
  //           statusCode: response.statusCode.toString()));
  //     }
  //   } on DioException catch (e) {
  //     if (e.response != null) {
  //       return Left(Failure(error: "API Error", statusCode: "404"));
  //     }
  //     return Left(Failure(error: e.error.toString(), statusCode: '0'));
  //   }
  // }
}
