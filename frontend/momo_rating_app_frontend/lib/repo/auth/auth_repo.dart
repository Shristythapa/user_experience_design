import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/config/constants/api_endpoints.dart';
import 'package:momo_rating_app_frontend/core/error/failure.dart';
import 'package:momo_rating_app_frontend/core/network/http_service.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';

final authRemoteRepoProvider = Provider((ref) => AuthRemoteRepo(
      dio: ref.read(httpServiceProvider),
      userSharedPrefs: ref.read(userSharedPrefsProvider),
    ));

class AuthRemoteRepo {
  final Dio dio;
  final UserSharedPrefs userSharedPrefs;

  AuthRemoteRepo({required this.userSharedPrefs, required this.dio});

  Future<Either<Failure, bool>> register(
      File image, String email, String username, String password) async {
    try {
      print(image);
      String fileName = image.path.split('/').last;
      FormData formData = FormData.fromMap(
        {
          'userName': username,
          'email': email,
          'password': password,
          'profilePicture': await MultipartFile.fromFile(
            image.path,
            filename: fileName,
          ),
        },
      );
      print(formData);

      Response response = await dio.post(ApiEndpoints.userRegister,
          data: formData,
          options: Options(headers: {'Content-Type': 'multipart/form-data'}));

      if (response.statusCode == 200) {
        var token = response.data['token'];
        var userData = response.data['userData'];
        await userSharedPrefs.setUserDetails(userData);
        await userSharedPrefs.setUserToken(token);
        return const Right(true);
      }
      return Left(Failure(
          error: response.data['message'],
          statusCode: response.statusCode.toString()));
    } on DioException catch (e) {
      print(e);
      if (e.response != null) {
        return Left(
            Failure(error: e.response!.data['message'], statusCode: e.response!.statusCode.toString()));
      }
      return Left(Failure(error: e.error.toString(), statusCode: '400'));
    }
  }

  Future<Either<Failure, bool>> login(String email, String password) async {
    try {
      FormData formData = FormData.fromMap(
        {
          'email': email,
          'password': password,
        },
      );

      Response response = await dio.post(
        ApiEndpoints.userLogin,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        var token = response.data['token'];
        var userData = response.data['userData'];
        await userSharedPrefs.setUserDetails(userData);
        await userSharedPrefs.setUserToken(token);
        return const Right(true);
      }
      return Left(Failure(
          error: response.data['message'],
          statusCode: response.statusCode.toString()));
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(Failure(
        error: e.response!.data['message'],
            statusCode: e.response!.statusCode.toString()
        ));
      }

      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, bool>> forgotPassword(String email) async {
    try {
      FormData formData = FormData.fromMap(
        {
          'email': email,
        },
      );

      Response response = await dio.post(
        ApiEndpoints.forgotPassword,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

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
            statusCode: e.response!.statusCode.toString()
        ));
      }

      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, bool>> resetPassword(
      String email, String otp, String newPassword) async {
    try {
      FormData formData = FormData.fromMap(
        {
          'email': email,
          'otpCode': otp,
          'newPassword': newPassword,
        },
      );

      Response response = await dio.post(
        ApiEndpoints.resetPassword,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

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
          statusCode: "404",
        ));
      }

      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }
}
