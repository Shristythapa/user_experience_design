import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/repo/auth/auth_repo.dart';
import 'package:momo_rating_app_frontend/screens/auth/add_preferences.dart';
import 'package:momo_rating_app_frontend/screens/auth/login.dart';
import 'package:momo_rating_app_frontend/screens/auth/reset_password.dart';
import 'package:momo_rating_app_frontend/screens/dashboard/main_dashboard_page.dart';
import 'package:momo_rating_app_frontend/viewmodel/state/auth_state.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>(
    (ref) => AuthViewModel(authRemoteRepo: ref.read(authRemoteRepoProvider)));

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRemoteRepo authRemoteRepo;

  AuthViewModel({required this.authRemoteRepo}) : super(AuthState.initial());

  void register(File image, String email, String username, String password,
      BuildContext context) {
    state = state.copyWith(isLoading: true);
    authRemoteRepo.register(image, email, username, password).then((value) {
      value.fold(
        (failure) {
          print(failure.error);
          state = state.copyWith(
              message: failure.error,
              isLoading: false,
              showMessage: true,
              isError: true);
        },
        (success) {
          state = state.copyWith(
              isLoading: false,
              showMessage: true,
              message: "Signed Up Sucessfully");
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPreferencesPage()),
          );
        },
      );
    });
  }

  void login(String email, String password, BuildContext context) {
    state = state.copyWith(isLoading: true);
    authRemoteRepo.login(email, password).then((value) {
      value.fold(
        (failure) => state = state.copyWith(
            message: failure.error,
            isLoading: false,
            showMessage: true,
            isError: true),
        (success) {
          state = state.copyWith(
              isLoading: false,
              showMessage: true,
              message: "Loged In Sucessfully");
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainDashboard()),
          );
        },
      );
    });
  }

  void forgotPassword(String email, BuildContext context) {
    state = state.copyWith(isLoading: true);
    authRemoteRepo.forgotPassword(email).then((value) {
      value.fold(
        (failure) => state.copyWith(
            message: failure.error,
            isLoading: false,
            showMessage: true,
            isError: true),
        (success) {
          state = state.copyWith(
              isLoading: false,
              showMessage: true,
              message: "OTP sent successfully");
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ResetPassword()),
          );
        },
      );
    });
  }

  void resetPassword(
      String email, String otp, String newPassword, BuildContext context) {
    state = state.copyWith(isLoading: true);
    authRemoteRepo.resetPassword(email, otp, newPassword).then((value) {
      value.fold(
        (failure) => state.copyWith(
            message: failure.error,
            isLoading: false,
            showMessage: true,
            isError: true),
        (success) {
          state = state.copyWith(
              isLoading: false,
              showMessage: true,
              message: "Password reset successfully");
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        },
      );
    });
  }

  void reset() {
    state = state.copyWith(
      isLoading: false,
      message: null,
      isError: false,
      showMessage: false,
    );
  }
}
