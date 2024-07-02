import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/core/model/momo/review_model.dart';
import 'package:momo_rating_app_frontend/repo/momo/review_repo.dart';
import 'package:momo_rating_app_frontend/screens/dashboard/main_dashboard_page.dart';
import 'package:momo_rating_app_frontend/viewmodel/state/rating_state.dart';

final reviewViewModelProvider =
    StateNotifierProvider.autoDispose<ReviewViewModel, RatingState>((ref) =>
        ReviewViewModel(reviewRepo: ref.read(reviewDataSourceProvider)));

class ReviewViewModel extends StateNotifier<RatingState> {
  final ReviewRepo reviewRepo;

  ReviewViewModel({required this.reviewRepo})
      : super(RatingState.initialState());

  Future resetState() async {
    state = RatingState.initialState();
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void addRating({required Review review, required BuildContext context}) {
    setLoading(true);

    reviewRepo.addRewiew(review).then((value) {
      value.fold(
          (failure) => state = state.copyWith(
              message: failure.error,
              isLoading: false,
              showMessage: true,
              isError: true), (success) {
        state = state.copyWith(
            isLoading: false,
            showMessage: true,
            message: "Review Added Sucessfully");

        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainDashboard()),
        );
      });
    });
  }
}
