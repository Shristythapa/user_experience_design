class AuthState {
  final bool isLoading;
  final bool? isError;
  final String? errorMessage;
  final bool? showMessage;
  final Map<String, dynamic>? user;

  AuthState(
      {required this.isLoading,
      this.isError,
      this.errorMessage,
      this.showMessage,
      this.user});

  factory AuthState.initial() {
    return AuthState(
        isLoading: false, isError: false, showMessage: false, errorMessage: "");
  }

  AuthState copyWith(
      {bool? isLoading,
      bool? isError,
      String? message,
      bool? showMessage,
      Map<String, dynamic>? user}) {
    return AuthState(
        isLoading: isLoading ?? this.isLoading,
        isError: isError ?? this.isError,
        showMessage: showMessage ?? this.showMessage,
        user: user ?? user);
  }
}
