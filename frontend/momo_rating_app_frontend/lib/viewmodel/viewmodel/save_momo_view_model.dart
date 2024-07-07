import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/repo/save_momo/save_momo_repo.dart';
import 'package:momo_rating_app_frontend/screens/dashboard/main_dashboard_page.dart';
import 'package:momo_rating_app_frontend/viewmodel/state/save_momo_state.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/dashboard_view_model.dart';

final saveMoMoViewModelProvider =
    StateNotifierProvider.autoDispose<SaveMoMoViewModel, SaveMomoState>((ref) =>
        SaveMoMoViewModel(
            saveMomoRepo: ref.read(saveMomoRepoProvider),
            dashboardViewModel: ref.read(dashboardViewModelProvider.notifier)));

class SaveMoMoViewModel extends StateNotifier<SaveMomoState> {
  final SaveMomoRepo saveMomoRepo;
  final DashboardViewModel dashboardViewModel;

  SaveMoMoViewModel(
      {required this.saveMomoRepo, required this.dashboardViewModel})
      : super(SaveMomoState.initialState());

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  Future resetState() async {
    state = SaveMomoState.initialState();
  }

  void saveMoMo({
    required String userId,
    required String momoId,
    required BuildContext context,
  }) {
    setLoading(true);

    saveMomoRepo.saveMoMo(userId: userId, momoId: momoId).then((value) {
      value.fold(
        (failure) {
          state = state.copyWith(
            message: failure.error,
            isLoading: false,
            showMessage: true,
            isError: true,
          );
        },
        (success) {
          state = state.copyWith(
            isLoading: false,
            showMessage: true,
            message: "Momo Saved Successfully",
          );
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MainDashboard(),
            ),
          ).then((_) {
            dashboardViewModel.changeIndex(4);
          });
        },
      );
    });
  }

  void removeSavedMomo({
    required String userId,
    required String momoId,
    required BuildContext context,
  }) {
    setLoading(true);

    saveMomoRepo.removeSavedMoMo(userId: userId, momoId: momoId).then((value) {
      value.fold(
        (failure) {
          state = state.copyWith(
            message: failure.error,
            isLoading: false,
            showMessage: true,
            isError: true,
          );
        },
        (success) {
          state = state.copyWith(
            isLoading: false,
            showMessage: true,
            message: "Momo Removed Successfully",
          );
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MainDashboard(),
            ),
          ).then((_) {
            dashboardViewModel.changeIndex(4);
          });
        },
      );
    });
  }

  Future<void> getSavedMomo(String userId) async {
    state.copyWith(isLoading: true);
    final result = await saveMomoRepo.getMomosByUserId(userId);
    result.fold(
        (failure) => state = state.copyWith(
            isError: true,
            message: failure.error,
            showMessage: true,
            isLoading: false), (data) {
      state = state.copyWith(momos: data, isLoading: false);
    });
  }
}
