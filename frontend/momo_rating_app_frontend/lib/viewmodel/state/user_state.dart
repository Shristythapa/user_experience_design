class UserState {
  final bool isLoading;
  final bool isError;
  final String? token;
  final Map<String, dynamic>? userDetails;
  final String? message;

  UserState({
    required this.isLoading,
    required this.isError,
    required this.token,
    required this.userDetails,
    required this.message,
  });

  factory UserState.initialState() => UserState(
        isLoading: false,
        isError: false,
        token: null,
        userDetails: null,
        message: null,
      );

  UserState copyWith({
    bool? isLoading,
    bool? isError,
    String? token,
    Map<String, dynamic>? userDetails,
    String? message,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      token: token ?? this.token,
      userDetails: userDetails ?? this.userDetails,
      message: message ?? this.message,
    );
  }
}
