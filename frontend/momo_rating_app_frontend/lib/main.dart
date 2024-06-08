import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/config/themes/theme.dart';
import 'package:momo_rating_app_frontend/screens/auth/login.dart';
import 'package:momo_rating_app_frontend/screens/auth/signup.dart';
import 'package:momo_rating_app_frontend/screens/dashboard/main_dashboard_page.dart';

enum Dite { veg, nonveg }

enum FillingType { chicken, pork, egg, tofu, paneer }

enum CookType { steam, fry, jhol }

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: const Color(0xffFFA70B),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: getApplicationTheme(false),
      home: const SignUp(),
    );
  }
}
