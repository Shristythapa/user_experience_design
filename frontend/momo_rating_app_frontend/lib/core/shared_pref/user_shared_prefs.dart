
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/core/error/failure.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final userSharedPrefsProvider = Provider<UserSharedPrefs>((ref) {
  return UserSharedPrefs();
});

class UserSharedPrefs {
  late SharedPreferences _sharedPreferences;

  Future<Either<Failure, bool>> setUserToken(String token) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      await _sharedPreferences.setString('token', token);
      return right(true);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, String?>> getUserToken() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      final token = _sharedPreferences.getString('token');
      return right(token);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, bool>> deleteUserToken() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      await _sharedPreferences.remove('token');
      return right(true);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, bool>> setUserDetails(
      Map<String, dynamic> userData) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      // Serialize the mentee data to JSON string
      String userJson = jsonEncode(userData);
      await _sharedPreferences.setString('user', userJson);
      return right(true);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> getUserDetails() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      String? userJson = _sharedPreferences.getString('user');
      if (userJson != null) {
        // Deserialize the JSON string to a map
        Map<String, dynamic> userData = jsonDecode(userJson);
        print(userData);
        return right(userData);
      } else {
        return left(Failure(error: 'user data not found'));
      }
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, bool>> deleteUserDetails() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      await _sharedPreferences.remove('user');
      return right(true);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }
}
