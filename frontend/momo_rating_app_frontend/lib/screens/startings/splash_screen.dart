import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:momo_rating_app_frontend/screens/dashboard/main_dashboard_page.dart';
import 'package:momo_rating_app_frontend/screens/startings/landing.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/user_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(userViewModelProvider.notifier).getUserDetails();
    navigateToNextScreen();
  }

  Future<void> _authenticate(Widget nextScreen) async {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => nextScreen));
  }

  Future<void> navigateToNextScreen() async {
    // Fetch the token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    // Parse the token if it exists
    final Map<String, dynamic>? decodedToken =
        token != null ? JwtDecoder.decode(token) : null;

    await Future.wait([
      Future.delayed(const Duration(seconds: 5)),
      Future.microtask(() => decodedToken),
    ]);

    if (decodedToken != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainDashboard()));
      return;
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const GetStarted()));
    }

    // Navigate to the next screen
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    return const SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "MoMoMatch",
                        style: TextStyle(
                          color: Color(0xffFFA70B),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "MoMo Rating and Recommendations",
                        style: TextStyle(
                          color: Color(0xffF1BA0C),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
