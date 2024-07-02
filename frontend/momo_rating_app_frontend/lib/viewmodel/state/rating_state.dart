class RatingState {
  final bool isLoading;
  final bool isError;
  final bool showMessage;
  final String message;

  RatingState({
    required this.isLoading,
    required this.isError,
    required this.showMessage,
    required this.message,
  });

  factory RatingState.initialState() => RatingState(
        isLoading: false,
        isError: false,
        showMessage: false,
        message: "",
      );

  RatingState copyWith({
    bool? isLoading,
    bool? isError,
    bool? showMessage,
    String? message,
  }) {
    return RatingState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      showMessage: showMessage ?? this.showMessage,
      message: message ?? this.message,
    );
  }
}


