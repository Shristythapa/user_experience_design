import 'package:momo_rating_app_frontend/screens/add/add_momo.dart';
import 'package:momo_rating_app_frontend/screens/auth/signup.dart';
import 'package:momo_rating_app_frontend/screens/startings/landing.dart';
import 'package:momo_rating_app_frontend/screens/auth/login.dart';

class AppRoutes {
  AppRoutes._();

  static const String landing = './landing';
  static const String signup = './signup';
  static const String login = './login';
  static const String add = './add';

  static getApplicationRoute() {
    return {
      landing: (context) => const GetStarted(),
      signup: (context) => const SignUp(),
      login: (context) => const Login(),
      add: (context) => const AddMoMo()
    };
  }
}
