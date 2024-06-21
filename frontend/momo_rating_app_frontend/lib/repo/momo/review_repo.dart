import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/config/constants/api_endpoints.dart';
import 'package:momo_rating_app_frontend/core/error/failure.dart';
import 'package:momo_rating_app_frontend/core/network/http_service.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/model/momo/review_model.dart';

final reviewDataSourceProvider = Provider((ref) => ReviewRepo(
    userSharedPrefs: ref.read(userSharedPrefsProvider),
    dio: ref.read(httpServiceProvider)));

class ReviewRepo {
  final Dio dio;
  final UserSharedPrefs userSharedPrefs;

  ReviewRepo({required this.userSharedPrefs, required this.dio});

  Future<Either<Failure, bool>> addRewiew(Review reviewModel) async {
    try {
      FormData formData = FormData.fromMap({
        'userId': reviewModel.userId,
        'momoId': reviewModel.momoId,
        'overallRating': reviewModel.overallRating,
        'fillingAmount': reviewModel.fillingAmount,
        'sizeOfMomo': reviewModel.sizeOfMomo,
        'sauceVariety': reviewModel.sauceVariety,
        'aesthectic': reviewModel.aesthectic,
        'spiceLevel': reviewModel.spiceLevel,
        'priceValue': reviewModel.priceValue,
        'review': reviewModel.review
      });

      Response response =
          await dio.post(ApiEndpoints.addReview, data: formData);
      print(response);

      if (response.statusCode == 200) {
        return const Right(true);
      }

      return Left(Failure(
          error: response.data['message'],
          statusCode: response.statusCode.toString()));
    } on DioException catch (e) {
      print(e);
      return Left(Failure(error: "error", statusCode: "404"));
    }
  }
}
