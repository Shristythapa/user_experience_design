import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/repo/save_momo/save_momo_repo.dart';
import 'package:momo_rating_app_frontend/screens/dashboard/main_dashboard_page.dart';
import 'package:momo_rating_app_frontend/viewmodel/state/save_momo_state.dart';

final saveMoMoViewModelProvider =
    StateNotifierProvider.autoDispose<SaveMoMoViewModel, SaveMomoState>((ref) =>
        SaveMoMoViewModel(saveMomoRepo: ref.read(saveMomoRepoProvider)));

class SaveMoMoViewModel extends StateNotifier<SaveMomoState> {
  final SaveMomoRepo saveMomoRepo;

  SaveMoMoViewModel({required this.saveMomoRepo})
      : super(SaveMomoState.initialState());

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void saveMoMo({
    required String userId,
    required String momoId,
    required BuildContext context,
  }) {
    setLoading(true);

    saveMomoRepo.saveMoMo(userId: userId, momoId: momoId).then((value) {
      value.fold(
        (failure) => state = state.copyWith(
          message: failure.error,
          isLoading: false,
          showMessage: true,
          isError: true,
        ),
        (success) {
          state = state.copyWith(
            isLoading: false,
            showMessage: true,
            message: "Momo Saved Successfully",
          );

          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainDashboard()),
          );
        },
      );
    });
  }
}
