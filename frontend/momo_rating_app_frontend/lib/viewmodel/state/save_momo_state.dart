import 'package:momo_rating_app_frontend/core/model/momo/momo_model.dart';

class SaveMomoState {
  final bool isLoading;
  final bool isError;
  final List<MoMoApiModel> momos;
  final bool showMessage;
  final String message;

  SaveMomoState({
    required this.isLoading,
    required this.isError,
    required this.momos,
    required this.showMessage,
    required this.message,
  });

  factory SaveMomoState.initialState() => SaveMomoState(
        isLoading: false,
        isError: false,
        momos: [],
        showMessage: false,
        message: "",
      );

  SaveMomoState copyWith({
    bool? isLoading,
    bool? isError,
    List<MoMoApiModel>? momos,
    bool? showMessage,
    String? message,
  }) {
    return SaveMomoState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      momos: momos ?? this.momos,
      showMessage: showMessage ?? this.showMessage,
      message: message ?? this.message,
    );
  }
}
