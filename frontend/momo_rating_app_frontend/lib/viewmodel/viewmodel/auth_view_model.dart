import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/repo/auth/auth_repo.dart';
import 'package:momo_rating_app_frontend/screens/dashboard/main_dashboard_page.dart';
import 'package:momo_rating_app_frontend/screens/startings/landing.dart';
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
        (failure) => state = state.copyWith(
            message: failure.error,
            isLoading: false,
            showMessage: true,
            isError: true),
        (success) {
          state = state.copyWith(
              isLoading: false,
              showMessage: true,
              message: "Signed Up Sucessfully");
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GetStarted()),
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
              message: "Signed Up Sucessfully");
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainDashboard()),
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
