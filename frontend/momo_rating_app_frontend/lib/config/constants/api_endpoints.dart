class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 8000);
  static const Duration receiveTimeout = Duration(seconds: 8000);

  static const String baseUrl = "http://192.168.97.63:5000/api/";

// auth routes
  static const String userRegister = "user/create";
  static const String userLogin = "user/login";

  //momo features
  static const String addMomo = "momo/add";
  static const String getAllMomo = "momo/getAllMomo";
  static const String getMomoById = "momo/getMomoById";
  static const String searchMomo = "momo/searchMomo";
  static const String recommendation = "momo/getRecommendations/";
  static const String popular = "momo/getPopularMomo";

  //review features
  static const String addReview = "ratings/addRating";
  static const String getRatingOfUser = "momo/getRatingByUser/";
  static const String getRatingById = "momo/getRatingById/";
  static const String deleteRating = "ratings/deleteRating/";

  //save momo
  static const String saveMomo = "saveMomo/saveMomo";
  static const String getSavedMomo = "saveMomo/savedMomos/";
  static const String removeSavedMomo = "saveMomo/removeSavedMomo";

  //forgot password
  static const String forgotPassword = "user/forgotPassword";
  static const String resetPassword = "user/resetPassword";

  // preferences route
  static const String addPreferences = "preferences/create";
  static const String viewPreferences = "preferences/getPreference/";
  static const String editPreferences = "preferences/edit/";
}
