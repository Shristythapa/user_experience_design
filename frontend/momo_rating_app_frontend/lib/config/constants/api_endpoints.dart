class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 8000);
  static const Duration receiveTimeout = Duration(seconds: 8000);
//   "http://192.168.56.1:5000/api/session/getAllSessions"
  // static const String baseUrl = "http://10.0.2.2:5000/api/";
  static const String baseUrl = "http://192.168.232.63:5000/api/";

// auth routes
  static const String userRegister = "user/create";
  static const String userLogin = "user/login";

  //momo features
  static const String addMomo = "momo/add";
}
