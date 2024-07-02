import 'package:momo_rating_app_frontend/core/model/preferences/preferences_model.dart';

class PreferenceState {
  final bool isLoading;
  final bool isError;
  final PreferenceModel? preferenceModel;
  final bool showMessage;
  final String message;

  PreferenceState({
    required this.isError,
    required this.isLoading,
    required this.preferenceModel,
    required this.showMessage,
    required this.message,
  });

  factory PreferenceState.initialState() => PreferenceState(
        isError: false,
        isLoading: false,
        preferenceModel: null,
        showMessage: false,
        message: "",
      );

  PreferenceState copyWith({
    bool? isError,
    bool? isLoading,
    PreferenceModel? preferenceModel,
    bool? showMessage,
    String? message,
  }) {
    return PreferenceState(
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
      preferenceModel: preferenceModel ?? this.preferenceModel,
      showMessage: showMessage ?? this.showMessage,
      message: message ?? this.message,
    );
  }
}
