import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/config/constants/api_endpoints.dart';
import 'package:momo_rating_app_frontend/core/error/failure.dart';
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

      if (response.statusCode == 200) {
        return const Right(true);
      }

      return Left(Failure(
          error: response.data['message'],
          statusCode: response.statusCode.toString()));
    } on DioException catch (e) {
      return Left(Failure(
          error: e.response!.data['message'],
          statusCode: e.response!.statusCode.toString()));
    }
  }

  Future<Either<Failure, List<Review>>> getAllRatingsByUser(
      String userId) async {
    try {
      Response response =
          await dio.get('${ApiEndpoints.getRatingOfUser}$userId');
      print(response);
      if (response.statusCode == 200) {
        List<Review> reviews = [];
        List ratings = response.data['ratings'];
        for (var rating in ratings) {
          String momoId = rating['momoId'];
          String shop = rating['shop'];
          String location = rating['location'];
          String cookType = rating['cookType'];
          String fillingType = rating['fillingType'];
          String image = rating['momoImage'];
          List reviewList = rating['ratings'];
          for (var reviewData in reviewList) {
            Review review = Review(
              reviewId: reviewData['_id'],
              userId: reviewData['userId'],
              momoId: momoId,
              shop: shop,
              location: location,
              cookType: cookType,
              fillingType: fillingType,
              image: image,
              overallRating: reviewData['overallRating'],
              fillingAmount: reviewData['fillingAmount'],
              sizeOfMomo: reviewData['sizeOfMomo'],
              sauceVariety: reviewData['sauceVariety'],
              aesthectic: reviewData['aesthectic'],
              spiceLevel: reviewData['spiceLevel'],
              priceValue: reviewData['priceValue'],
              review: reviewData['review'],
            );
            reviews.add(review);
          }
        }

        return Right(reviews);
      }

      return Left(Failure(
          error: response.data['message'],
          statusCode: response.statusCode.toString()));
    } on DioException catch (e) {
      return Left(Failure(
          error: e.response!.data['message'],
          statusCode: e.response!.statusCode.toString()));
    } catch (e) {
      return Left(Failure(error: "Unexpected error", statusCode: "500"));
    }
  }

  Future<Either<Failure, Review>> getRatingById(String ratingId) async {
    try {
      Response response =
          await dio.get('${ApiEndpoints.getRatingById}$ratingId');
      print(response);
      if (response.statusCode == 200) {
        Review review = Review(
            userId: response.data["rating"]["userId"],
            momoId: response.data["momo"]["momoId"],
            reviewId: response.data["rating"]["_id"],
            overallRating: response.data["rating"]["overallRating"],
            fillingAmount: response.data["rating"]["fillingAmount"],
            sizeOfMomo: response.data["rating"]["sizeOfMomo"],
            sauceVariety: response.data["rating"]["sauceVariety"],
            aesthectic: response.data["rating"]["aesthectic"],
            spiceLevel: response.data["rating"]["spiceLevel"],
            priceValue: response.data["rating"]["priceValue"],
            review: response.data["rating"]["review"],
            cookType: response.data["momo"]["cookType"],
            fillingType: response.data['momo']['fillingType'],
            shop: response.data["momo"]["shop"],
            location: response.data["momo"]["location"],
            image: response.data["momo"]["momoImage"]);

        return Right(review);
      }

      return Left(Failure(
          error: response.data['message'],
          statusCode: response.statusCode.toString()));
    } on DioException catch (e) {
      print(e);
      return Left(Failure(
          error: e.response!.data['message'],
          statusCode: e.response!.statusCode.toString()));
    } catch (e) {
      return Left(Failure(error: "Unexpected error", statusCode: "500"));
    }
  }

  Future<Either<Failure, bool>> deleteReview({required String reviewId}) async {
    try {
      final response = await dio.post(ApiEndpoints.deleteRating + reviewId);

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
}
