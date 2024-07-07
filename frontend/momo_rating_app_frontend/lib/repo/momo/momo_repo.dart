import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/config/constants/api_endpoints.dart';
import 'package:momo_rating_app_frontend/core/error/failure.dart';
import 'package:momo_rating_app_frontend/core/network/http_service.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/core/model/momo/momo_model.dart';
import 'package:momo_rating_app_frontend/main.dart';

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
        return Left(Failure(
            error: e.response!.data['message'],
            statusCode: e.response!.statusCode.toString()));
      }
      return Left(Failure(error: e.error.toString(), statusCode: '0'));
    }
  }

  Future<Either<Failure, List<MoMoApiModel>>> getAllMomos() async {
    try {
      Response response = await dio.get(
        ApiEndpoints.getAllMomo,
      );

      if (response.statusCode == 200) {
        var momos = response.data['momos'];

        List<MoMoApiModel> momoList = [];
        for (var momo in momos) {
          momoList.add(MoMoApiModel(
              id: momo['_id'],
              userId: momo['userId'],
              momoPrice: momo['momoPrice'].toString(),
              cookType: momo['cookType'],
              momoImage: momo['momoImage'],
              fillingType: momo['fillingType'],
              location: momo['location'],
              overallRating: momo['overallRating'].toDouble(),
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
      return Left(Failure(
          error: e.response!.data['message'],
          statusCode: e.response!.statusCode.toString()));
    }
  }

  Future<Either<Failure, MoMoApiModel>> getMoMoById(
      {required String momoId, required String userId}) async {
    try {
      print(ApiEndpoints.getMomoById);
      final response = await dio.get(
        ApiEndpoints.getMomoById,
        queryParameters: {
          'momoId': momoId,
          'userId': userId,
        },
      );
      print(response);

      if (response.statusCode == 200) {
        if (response.statusCode == 200) {
          final momoData = response.data['data']['momo'];
          momoData['isSaved'] = response.data['data']['momoSaved'];

          final moMoApiModel = MoMoApiModel.fromJson(momoData);

          return Right(moMoApiModel);
        } else {
          return Left(Failure(
            error: response.data['error'] ?? 'Unexpected error',
            statusCode: response.statusCode.toString(),
          ));
        }
      } else {
        return Left(Failure(
          error: response.data['error'] ?? 'Unexpected error',
          statusCode: response.statusCode.toString(),
        ));
      }
    } on DioException catch (e) {
      return Left(Failure(
        error: e.response?.data['message'] ?? 'API connection error',
        statusCode: e.response?.statusCode.toString() ?? '404',
      ));
    } catch (e) {
      return Left(Failure(
        error: e.toString(),
        statusCode: '500',
      ));
    }
  }

  Future<Either<Failure, List<MoMoApiModel>>> searchMomo(
      {String? query, List<FillingType>? filling, List<CookType>? cook}) async {
    try {
      // Create an empty map for formData
      Map<String, dynamic> formData = {};

      // Add 'query' to formData if not null or empty
      if (query != null && query.isNotEmpty) {
        formData['query'] = query;
      }

      // Add 'filling' to formData if not null and not empty
      if (filling != null && filling.isNotEmpty) {
        formData['filling'] = filling.map((type) => '{$type}').toList();
      }

      // Add 'cook' to formData if not null and not empty
      if (cook != null && cook.isNotEmpty) {
        formData['cook'] = cook.map((type) => '{$type}').toList();
      }

      // Create FormData object from the formData map
      FormData formDataObject = FormData.fromMap(formData);
      final response =
          await dio.post(ApiEndpoints.searchMomo, data: formDataObject);

      if (response.statusCode == 200) {
        var momos = response.data['data'];

        List<MoMoApiModel> momoList = [];
        for (var momo in momos) {
          momoList.add(MoMoApiModel(
              id: momo['_id'],
              userId: momo['userId']['_id'],
              momoPrice: momo['momoPrice'].toString(),
              cookType: momo['cookType'],
              momoImage: momo['momoImage'],
              fillingType: momo['fillingType'],
              location: momo['location'],
              overallRating: momo['overallRating'].toDouble(),
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
      return Left(Failure(
          error: e.response!.data['message'],
          statusCode: e.response!.statusCode.toString()));
    }
  }

  Future<Either<Failure, List<MoMoApiModel>>> getRecommendations(
      String id) async {
    try {
      Response response = await dio.get(ApiEndpoints.recommendation + id);

      if (response.statusCode == 200) {
        var momos = response.data['momo'];
        print(momos);
        List<MoMoApiModel> momoList = [];
        for (var momo in momos) {
          momoList.add(MoMoApiModel(
              id: momo['_id'],
              userId: momo['userId'],
              momoPrice: momo['momoPrice'].toString(),
              cookType: momo['cookType'],
              momoImage: momo['momoImage'],
              fillingType: momo['fillingType'],
              location: momo['location'],
              overallRating: momo['overallRating'].toDouble(),
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
      return Left(Failure(
          error: e.response!.data['message'],
          statusCode: e.response!.statusCode.toString()));
    }
  }

  Future<Either<Failure, List<MoMoApiModel>>> getpopular() async {
    try {
      Response response = await dio.get(ApiEndpoints.popular);

      if (response.statusCode == 200) {
        var momos = response.data['momos'];
        print(momos);
        List<MoMoApiModel> momoList = [];
        for (var momo in momos) {
          momoList.add(MoMoApiModel(
              id: momo['_id'],
              userId: momo['userId'],
              momoPrice: momo['momoPrice'].toString(),
              cookType: momo['cookType'],
              momoImage: momo['momoImage'],
              fillingType: momo['fillingType'],
              location: momo['location'],
              overallRating: momo['overallRating'].toDouble(),
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
      return Left(Failure(
          error: e.response!.data['message'],
          statusCode: e.response!.statusCode.toString()));
    }
  }
}
