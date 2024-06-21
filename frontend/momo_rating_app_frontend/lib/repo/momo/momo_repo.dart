import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/config/constants/api_endpoints.dart';
import 'package:momo_rating_app_frontend/core/error/failure.dart';
import 'package:momo_rating_app_frontend/core/network/http_service.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/model/momo/momo_model.dart';
import 'package:momo_rating_app_frontend/model/momo/review_model.dart';

final momoDataSourceProvider = Provider((ref) => MoMoRemoteRepo(
      dio: ref.read(httpServiceProvider),
      userSharedPrefs: ref.read(userSharedPrefsProvider),
    ));

class MoMoRemoteRepo {
  final Dio dio;
  final UserSharedPrefs userSharedPrefs;

  MoMoRemoteRepo({required this.userSharedPrefs, required this.dio});

  Future<Either<Failure, bool>> addMoMo(
      {required File image,
      required MoMoApiModel moMoApiModel,
      required int overallRating,
      required int fillingAmount,
      required int sizeOfMomo,
      required int sauceVariety,
      required int aesthetic,
      required int spiceLevel,
      required int priceValue,
      required String textReview}) async {
    String fileName = image.path.split('/').last;
    try {
      FormData formData = FormData.fromMap({
        'userId': moMoApiModel.userId,
        'momoName': moMoApiModel.momoName,
        'momoImage': await MultipartFile.fromFile(
          image.path,
          filename: fileName,
        ),
        'momoPrice': moMoApiModel.momoPrice,
        'cookType': moMoApiModel.cookType,
        'fillingType': moMoApiModel.fillingType,
        'location': moMoApiModel.location,
        'shop': moMoApiModel.shop,
        'overallRating': overallRating,
        'fillingAmount': fillingAmount,
        'sizeOfMomo': sizeOfMomo,
        'sauceVariety': sauceVariety,
        'aesthetic': aesthetic,
        'spiceLevel': spiceLevel,
        'priceValue': priceValue,
        'review': textReview
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
        return Left(Failure(error: "Api Error", statusCode: "404"));
      }
      return Left(Failure(error: e.error.toString(), statusCode: '0'));
    }
  }

  Future<Either<Failure, List<MoMoApiModel>>> getAllMomos() async {
    try {
      print(ApiEndpoints.getAllMomo);
      Response response = await dio.get(
        ApiEndpoints.getAllMomo,
      );

      print(response);
      if (response.statusCode == 200) {
        var momos = response.data['momos'];

        List<MoMoApiModel> momoList = [];
        for (var momo in momos) {
          momoList.add(MoMoApiModel(
              id: momo['_id'],
              userId: momo['userId'],
              momoName: momo['momoName'],
              momoPrice: momo['momoPrice'].toString(),
              cookType: momo['cookType'],
              momoImage: momo['momoImage'],
              fillingType: momo['fillingType'],
              location: momo['location'],
              shop: momo['shop']));
        }

        return Right(momoList);
      } else {
        return Left(Failure(
            error: response.statusMessage.toString(),
            statusCode: response.statusCode.toString()));
      }
    } on DioException catch (e) {
      print((e));
      return Left(Failure(error: "Get All Session: Api connection error"));
    }
  }

  Future<Either<Failure, MoMoApiModel>> getMoMoById(String id) async {
    try {
      final response = await dio.get('${ApiEndpoints.getMomoById}$id');

      if (response.statusCode == 200) {
        final momoData = response.data['data'];

        // Parse reviews
        List<Review> reviews = (momoData['reviews'] as List).map((reviewJson) {
          return Review(
            reviewId: reviewJson['_id'],
            userId: reviewJson['userId'],
            momoId: momoData[
                '_id'], // Assuming momoId should be the same as the fetched momo
            overallRating: reviewJson['overallRating'],
            fillingAmount: reviewJson['fillingAmount'],
            sizeOfMomo: reviewJson['sizeOfMomo'],
            sauceVariety: reviewJson['sauceVariety'],
            aesthectic: reviewJson['aesthectic'],
            spiceLevel: reviewJson['spiceLevel'],
            priceValue: reviewJson['priceValue'],
            review: reviewJson['review'],
          );
        }).toList();

        // Parse momo
        final moMoApiModel = MoMoApiModel(
          id: momoData['_id'],
          momoImage: momoData['momoImage'],
          userId: momoData['userId'],
          momoName: momoData['momoName'],
          momoPrice: momoData['momoPrice'].toString(),
          cookType: momoData['cookType'],
          fillingType: momoData['fillingType'],
          location: momoData['location'],
          shop: momoData['shop'],
          reviews: reviews,
        );

        return Right(moMoApiModel);
      } else {
        return Left(Failure(
          error: response.data['error'] ?? 'Unexpected error',
          statusCode: response.statusCode.toString(),
        ));
      }
    } on DioException catch (e) {
      return Left(Failure(
        error: e.response?.data['error'] ?? 'API connection error',
        statusCode: e.response?.statusCode.toString() ?? '404',
      ));
    } catch (e) {
      return Left(Failure(
        error: e.toString(),
        statusCode: '500',
      ));
    }
  }
}
