import 'package:momo_rating_app_frontend/core/model/momo/momo_model.dart';

class PopularMomoState {
  final bool isLoading;
  final bool isError;
  final List<MoMoApiModel> momo;
  final bool showMessage;
  final String message;

  PopularMomoState({
    required this.isError,
    required this.isLoading,
    required this.momo,
    required this.showMessage,
    required this.message,
  });

  factory PopularMomoState.initialState() => PopularMomoState(
        isError: false,
        isLoading: false,
        momo: [],
        showMessage: false,
        message: "",
      );

  PopularMomoState copyWith({
    bool? isError,
    bool? isLoading,
    List<MoMoApiModel>? momo,
    bool? showMessage,
    String? message,
  }) {
    return PopularMomoState(
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
      momo: momo ?? this.momo,
      showMessage: showMessage ?? this.showMessage,
      message: message ?? this.message,
    );
  }
}
