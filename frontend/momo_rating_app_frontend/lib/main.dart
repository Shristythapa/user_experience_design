import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/config/themes/theme.dart';
import 'package:momo_rating_app_frontend/screens/startings/splash_screen.dart';

enum FillingType { Chicken, Pork, Egg, Tofu, Paneer, Vegetables, Buff, Sea }

enum CookType { Steam, Fry, Jhol, Kothe, CMoMo }

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: const Color(0xffFFA70B),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: getApplicationTheme(false),
      home: const SplashScreen(),
    );
  }
}
