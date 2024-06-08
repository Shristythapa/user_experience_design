import 'package:flutter/material.dart';

class SnackBarManager {
  static bool isSnackBarVisible = false;

  static void showSnackBar(
      {required String message,
      required BuildContext context,
      required bool isError}) {
    if (!isSnackBarVisible) {
      isSnackBarVisible = true;

      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: isError ? Colors.red : Colors.green,
              duration: const Duration(seconds: 5),
              behavior: SnackBarBehavior.floating,
            ),
          )
          .closed
          .then((_) {
        isSnackBarVisible = false;
      });
    }
  }
}
