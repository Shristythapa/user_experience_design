import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/repo/momo/momo_repo.dart';
import 'package:momo_rating_app_frontend/repo/momo/review_repo.dart';
import 'package:momo_rating_app_frontend/viewmodel/state/recommendation_momo_state.dart';

final recommedationMomoViewModelProvider =
    StateNotifierProvider<RecommendationMomoViewModel, RecommendationMomoState>(
        (ref) => RecommendationMomoViewModel(
            moMoRemoteRepo: ref.read(momoDataSourceProvider),
            reviewRepo: ref.read(reviewDataSourceProvider)));

class RecommendationMomoViewModel
    extends StateNotifier<RecommendationMomoState> {
  final MoMoRemoteRepo moMoRemoteRepo;
  final ReviewRepo reviewRepo;
  RecommendationMomoViewModel(
      {required this.moMoRemoteRepo, required this.reviewRepo})
      : super(RecommendationMomoState.initialState());

  Future resetState() async {
    state = RecommendationMomoState.initialState();
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  Future<void> getRecommendations(String id) async {
    state.copyWith(isLoading: true);
    final result = await moMoRemoteRepo.getRecommendations(id);
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
