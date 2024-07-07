import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/config/constants/api_endpoints.dart';
import 'package:momo_rating_app_frontend/core/error/failure.dart';
import 'package:momo_rating_app_frontend/core/model/momo/momo_model.dart';
import 'package:momo_rating_app_frontend/core/network/http_service.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';

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
        return Left(Failure(
            error: e.response!.data['message'],
            statusCode: e.response!.statusCode.toString()));
      }
      return Left(Failure(error: e.error.toString(), statusCode: '0'));
    }
  }

  Future<Either<Failure, bool>> removeSavedMoMo({
    required String userId,
    required String momoId,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'userId': userId,
        'momoId': momoId,
      });

      Response response = await dio.post(
        ApiEndpoints.removeSavedMomo,
        data: formData,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return const Right(true);
      }

      return Left(Failure(
        error: response.data['message'] ?? 'Unknown error',
        statusCode: response.statusCode.toString(),
      ));
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(Failure(
          error: e.response!.data['message'] ?? 'API Error',
          statusCode: e.response!.statusCode.toString(),
        ));
      } else {
        return Left(Failure(
          error: 'Network Error: ${e.message}',
          statusCode: '0',
        ));
      }
    } catch (e) {
      return Left(Failure(
        error: 'Unexpected Error: $e',
        statusCode: '500',
      ));
    }
  }

  Future<Either<Failure, List<MoMoApiModel>>> getMomosByUserId(
      String userId) async {
    try {
      final response = await dio.get('${ApiEndpoints.getSavedMomo}$userId');
      if (response.statusCode == 200) {
        print(response);
        var momos = response.data['data'];
        List<MoMoApiModel> momoList = [];
        for (var momo in momos) {
          momoList.add(MoMoApiModel(
              id: momo['momoId']['_id'],
              userId: momo['userId'],
              momoPrice: momo['momoId']['momoPrice'].toString(),
              cookType: momo['momoId']['cookType'],
              momoImage: momo['momoId']['momoImage'],
              fillingType: momo['momoId']['fillingType'],
              location: momo['momoId']['location'],
              overallRating: momo['momoId']['overallRating'].toDouble(),
              shop: momo['momoId']['shop']));
        }
        return Right(momoList);
      } else {
        return Left(Failure(
            error: response.data['message'],
            statusCode: response.statusCode.toString()));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(Failure(error: "API Error", statusCode: "404"));
      }
      return Left(Failure(error: e.error.toString(), statusCode: '0'));
    }
  }
}
