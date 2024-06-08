import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/config/constants/api_endpoints.dart';
import 'package:momo_rating_app_frontend/core/error/failure.dart';
import 'package:momo_rating_app_frontend/core/network/http_service.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/model/momo/momo_model.dart';

final momoDataSourceProvider = Provider((ref) => MoMoRemoteRepo(
      dio: ref.read(httpServiceProvider),
      userSharedPrefs: ref.read(userSharedPrefsProvider),
    ));

class MoMoRemoteRepo {
  final Dio dio;
  final UserSharedPrefs userSharedPrefs;

  MoMoRemoteRepo({required this.userSharedPrefs, required this.dio});

  Future<Either<Failure, bool>> addMoMo(
      File image, MoMoApiModel moMoApiModel) async {
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
        'location': moMoApiModel.location
      });

      Response response = await dio.post(ApiEndpoints.addMomo,
          data: formData,
          options: Options(headers: {'Content-Type': 'multipart/form-data'}));

      if (response.statusCode == 200) {
        return const Right(true);
      }

      return Left(Failure(
          error: response.data['data'],
          statusCode: response.statusCode.toString()));
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(
            Failure(error: e.response!.data['message'], statusCode: "404"));
      }
      return Left(Failure(error: e.error.toString(), statusCode: '0'));
    }
  }
}
