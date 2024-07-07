import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/core/model/preferences/preferences_model.dart';
import 'package:momo_rating_app_frontend/screens/dashboard/main_dashboard_page.dart';
import 'package:momo_rating_app_frontend/screens/profile/my_preferences.dart';
import 'package:momo_rating_app_frontend/viewmodel/state/preference_state.dart';
import 'package:momo_rating_app_frontend/repo/preferences/preferences_repo.dart';

final preferenceViewModelProvider =
    StateNotifierProvider.autoDispose<PreferenceViewModel, PreferenceState>(
        (ref) => PreferenceViewModel(
            preferencesRepo: ref.read(preferenceDataSourceProvider)));

class PreferenceViewModel extends StateNotifier<PreferenceState> {
  final PreferenceRepo preferencesRepo;

  PreferenceViewModel({required this.preferencesRepo})
      : super(PreferenceState.initialState());

  Future<void> resetState() async {
    state = state.copyWith(isLoading: false, showMessage: false, message: "");
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void addPreference(PreferenceModel preferenceModel, BuildContext context) {
    setLoading(true);
    preferencesRepo.addPreferences(preferenceModel).then((value) {
      value.fold(
          (failure) => state = state.copyWith(
              message: failure.error,
              isLoading: false,
              showMessage: true,
              isError: true), (success) {
        state = state.copyWith(
            isLoading: false,
            showMessage: true,
            message: "Preferences Added Sucessfully");
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainDashboard()),
        );
      });
    });
  }

  void getPreferences(BuildContext context) {
    setLoading(true);
    preferencesRepo.getPreferences().then((value) {
      value.fold(
          (failure) => state = state.copyWith(
              message: failure.error,
              isLoading: false,
              showMessage: true,
              isError: true), (success) {
        print(success);
        state = state.copyWith(
            isLoading: false,
            isError: false,
            showMessage: false,
            preferenceModel: success,
            message: "Preferences Get Sucessfull");
      });
    });
  }

  void editPreference(PreferenceModel preferenceModel, BuildContext context) {
    setLoading(true);
    preferencesRepo.editPreferences(preferenceModel).then((value) {
      value.fold(
          (failure) => state = state.copyWith(
              message: failure.error,
              isLoading: false,
              showMessage: true,
              isError: true), (success) {
        state = state.copyWith(
            isLoading: false,
            showMessage: true,
            message: "Preferences Edit Sucessfully");
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyPreferences()),
        );
      });
    });
  }
}
