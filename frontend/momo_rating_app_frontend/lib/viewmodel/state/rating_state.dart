import 'package:momo_rating_app_frontend/core/model/momo/review_model.dart';

class RatingState {
  final bool isLoading;
  final bool isError;
  final bool showMessage;
  final String message;
  final List<Review> review;
  RatingState(
      {required this.isLoading,
      required this.isError,
      required this.showMessage,
      required this.message,
      required  this.review});

  factory RatingState.initialState() => RatingState(
        isLoading: false,
        isError: false,
        showMessage: false,
        message: "",
        review: []
      );

  RatingState copyWith(
      {bool? isLoading,
      bool? isError,
      bool? showMessage,
      String? message,
      List<Review>? review}) {
    return RatingState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      showMessage: showMessage ?? this.showMessage,
      message: message ?? this.message,
      review: review ?? this.review,
    );
  }
}
