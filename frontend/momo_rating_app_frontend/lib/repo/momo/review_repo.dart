import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/config/constants/api_endpoints.dart';
import 'package:momo_rating_app_frontend/core/error/failure.dart';
import 'package:momo_rating_app_frontend/core/model/momo/momo_model.dart';
import 'package:momo_rating_app_frontend/core/network/http_service.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/core/model/momo/review_model.dart';

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
      return Left(Failure(error: "Network Error", statusCode: "404"));
    }
  }

  Future<Either<Failure, List<Review>>> getAllRatingsByUser(
      String userId) async {
    try {
      Response response =
          await dio.get('${ApiEndpoints.getRatingOfUser}$userId');

      if (response.statusCode == 200) {
        // Assuming your API returns a list of ratings in JSON format
        List<dynamic> data = response
            .data['data']; // Adjust based on actual API response structure
        List<Review> ratings =
            data.map((json) => Review.fromJson(json, json['momoId'])).toList();
        return Right(ratings);
      }

      return Left(Failure(
          error: response.data['message'],
          statusCode: response.statusCode.toString()));
    } on DioException catch (e) {
      print(e);
      return Left(Failure(error: e.toString(), statusCode: "404"));
    } catch (e) {
      return Left(Failure(error: "Unexpected error", statusCode: "500"));
    }
  }

  Future<Either<Failure, Review>> getRatingById(String ratingId) async {
    try {
      Response response = await dio.get('${ApiEndpoints.getRatingById}$ratingId');

      if (response.statusCode == 200) {
        var ratingData = response.data['rating'];
        var momoData = response.data['momo'];

        Review review = Review.fromJson(ratingData,response.data['momo']['momoId']);
        MoMoApiModel momo = MoMoApiModel.fromJson(momoData);

        return Right(review);
      }

      return Left(Failure(
          error: response.data['message'],
          statusCode: response.statusCode.toString()));
    } on DioException catch (e) {
      print(e);
      return Left(Failure(error: e.toString(), statusCode: "404"));
    } catch (e) {
      return Left(Failure(error: "Unexpected error", statusCode: "500"));
    }
  }
}


