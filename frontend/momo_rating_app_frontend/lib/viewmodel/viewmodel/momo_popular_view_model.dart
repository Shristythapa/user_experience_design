
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/repo/momo/momo_repo.dart';
import 'package:momo_rating_app_frontend/repo/momo/review_repo.dart';
import 'package:momo_rating_app_frontend/viewmodel/state/momo_popular_state.dart';

final popularMomoViewModelProvider = StateNotifierProvider<PopularMomoViewModel, PopularMomoState>(
    (ref) => PopularMomoViewModel(
        moMoRemoteRepo: ref.read(momoDataSourceProvider),
        reviewRepo: ref.read(reviewDataSourceProvider)));

class PopularMomoViewModel extends StateNotifier<PopularMomoState> {
  final MoMoRemoteRepo moMoRemoteRepo;
  final ReviewRepo reviewRepo;
  PopularMomoViewModel({required this.moMoRemoteRepo, required this.reviewRepo})
      : super(PopularMomoState.initialState()) {
    getPopular();
  }

  Future resetState() async {
    state = PopularMomoState.initialState();
    getPopular();
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }


  Future<void> getPopular() async {
    state.copyWith(isLoading: true);
    final result = await moMoRemoteRepo.getpopular();
    result.fold(
        (failure) => state = state.copyWith(
            isError: true,
            message: failure.error,
            showMessage: true,
            isLoading: false), (data) {
      state = state.copyWith(momo: data, isLoading: false);
    });
  }


 
}
