import 'package:flutter/material.dart';
import 'package:momo_rating_app_frontend/config/constants/theme_constant.dart';

ThemeData getApplicationTheme(bool isDark) {
  return ThemeData(
    colorScheme: isDark
        ? const ColorScheme.dark(
            primary: ThemeConstant.darkPrimaryColor,
          )
        : const ColorScheme.light(
            primary: ThemeConstant.primaryColor,
          ),
    brightness: isDark ? Brightness.dark : Brightness.light,
    fontFamily: 'Montserrat',
    useMaterial3: true,
    scaffoldBackgroundColor: isDark ? Colors.black : Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
    ),
    primaryColor: isDark
        ? const Color(0xff1f1f1f)
        : const Color.fromARGB(255, 249, 243, 255),
    secondaryHeaderColor: isDark ? const Color(0xff1f1f1f) : Colors.white,
    primaryColorDark: isDark ? Colors.white : Colors.black,
    primaryColorLight: isDark ? Colors.white : const Color(0xFFFFA70B),
    bottomNavigationBarTheme: isDark
        ? const BottomNavigationBarThemeData(
            backgroundColor: Color(0xff1f1f1f),
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(color: Color(0xFFdabcff)),
            unselectedLabelStyle: TextStyle(color: Color(0xFF888888)),
            unselectedItemColor: Colors.white,
            selectedItemColor: Color(0xFFEEA025),
          )
        : const BottomNavigationBarThemeData(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(color: Color(0xFFdabcff)),
            unselectedLabelStyle: TextStyle(color: Color(0xFF000000)),
            unselectedItemColor: Color(0xFF000000),
            selectedItemColor: Color(0xFFEEA025),
          ),
    elevatedButtonTheme: isDark
        ? ElevatedButtonThemeData(
            style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return const Color(0xFFFFA70B);
              },
            ),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ))
        : ElevatedButtonThemeData(
            style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return const Color(0xFFFFA70B);
              },
            ),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          )),
    textTheme: TextTheme(
      //for light
      titleLarge: isDark
          ? const TextStyle(
              color: Colors.white,
              fontFamily: 'nunitoSans',
            )
          : const TextStyle(
              color: Colors.black,
              fontFamily: 'nunitoSans',
            ),
      titleMedium: isDark
          ? const TextStyle(
              color: Colors.white,
              fontFamily: 'nunitoSans',
            )
          : const TextStyle(
              color: Color(0xFFFFA70B),
              fontFamily: 'nunitoSans',
            ),
      headlineLarge: const TextStyle(
          color: Color(0xFF9A9A9A), fontSize: 12, fontFamily: 'nunitoSans'),
      headlineMedium: const TextStyle(
          color: Color(0xFFFFA70B), fontSize: 10, fontFamily: 'nunitoSans'),
      headlineSmall: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: Color(0xFF444444),
        fontFamily: 'nunitoSans',
      ),
    ),
  );
}
