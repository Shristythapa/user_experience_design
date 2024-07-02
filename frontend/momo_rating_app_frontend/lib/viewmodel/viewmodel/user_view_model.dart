import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/core/shared_pref/user_shared_prefs.dart';
import 'package:momo_rating_app_frontend/viewmodel/state/user_state.dart';

final userViewModelProvider = StateNotifierProvider<UserViewModel, UserState>(
  (ref) => UserViewModel(userSharedPrefs: ref.read(userSharedPrefsProvider)),
);

class UserViewModel extends StateNotifier<UserState> {
  final UserSharedPrefs userSharedPrefs;

  UserViewModel({required this.userSharedPrefs})
      : super(UserState.initialState());

  Future<void> setUserToken(String token) async {
    state = state.copyWith(isLoading: true);
    final result = await userSharedPrefs.setUserToken(token);
    result.fold(
      (failure) => state = state.copyWith(
        isError: true,
        message: failure.error,
        isLoading: false,
      ),
      (success) => state = state.copyWith(
        isLoading: false,
        message: 'Token set successfully',
        isError: false,
      ),
    );
  }

  Future<void> getUserToken() async {
    state = state.copyWith(isLoading: true);
    final result = await userSharedPrefs.getUserToken();
    result.fold(
      (failure) => state = state.copyWith(
        isError: true,
        message: failure.error,
        isLoading: false,
      ),
      (token) => state = state.copyWith(
        isLoading: false,
        token: token,
        isError: false,
      ),
    );
  }

  Future<void> deleteUserToken() async {
    state = state.copyWith(isLoading: true);
    final result = await userSharedPrefs.deleteUserToken();
    result.fold(
      (failure) => state = state.copyWith(
        isError: true,
        message: failure.error,
        isLoading: false,
      ),
      (success) => state = state.copyWith(
        isLoading: false,
        message: 'Token deleted successfully',
        isError: false,
        token: null,
      ),
    );
  }

  Future<void> setUserDetails(Map<String, dynamic> userDetails) async {
    state = state.copyWith(isLoading: true);
    final result = await userSharedPrefs.setUserDetails(userDetails);
    result.fold(
      (failure) => state = state.copyWith(
        isError: true,
        message: failure.error,
        isLoading: false,
      ),
      (success) => state = state.copyWith(
        isLoading: false,
        message: 'User details set successfully',
        isError: false,
      ),
    );
  }

  Future<void> getUserDetails() async {
    state = state.copyWith(isLoading: true);
    final result = await userSharedPrefs.getUserDetails();
    result.fold(
      (failure) => state = state.copyWith(
        isError: true,
        message: failure.error,
        isLoading: false,
      ),
      (details) => state = state.copyWith(
        isLoading: false,
        userDetails: details,
        isError: false,
      ),
    );
  }

  Future<void> deleteUserDetails() async {
    state = state.copyWith(isLoading: true);
    final result = await userSharedPrefs.deleteUserDetails();
    result.fold(
      (failure) => state = state.copyWith(
        isError: true,
        message: failure.error,
        isLoading: false,
      ),
      (success) => state = state.copyWith(
        isLoading: false,
        message: 'User details deleted successfully',
        isError: false,
        userDetails: null,
      ),
    );
  }

  void resetState() {
    state = UserState.initialState();
  }
}
