import 'package:momo_rating_app_frontend/model/momo/momo_model.dart';

class MoMoState {
  final bool isLoading;
  final bool isError;
  final List<MoMoApiModel> momo;
  final bool showMessage;
  final String message;

  MoMoState({
    required this.isError,
    required this.isLoading,
    required this.momo,
    required this.showMessage,
    required this.message,
  });

  factory MoMoState.initialState() => MoMoState(
        isError: false,
        isLoading: false,
        momo: [],
        showMessage: false,
        message: "",
      );

  MoMoState copyWith(
      {bool? isError,
      bool? isLoading,
      List<MoMoApiModel>? momo,
      bool? showMessage,
      bool? hasReachedMax,
      int? page,
      String? message}) {
    return MoMoState(
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
      momo: momo ?? this.momo,
      showMessage: showMessage ?? this.showMessage,
      message: message ?? this.message,
    );
  }
}
