import 'package:flutter/material.dart';
import 'package:travel/utils/rgb_utils.dart';
import 'package:travel/utils/navigator_key.dart';

class SnackBarUtils {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
      {required String title, required bool isError, int duration = 1}) {
    return ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(title),
        backgroundColor: isError ? RGB.dangerLight : RGB.succeeLight,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: duration),
      ),
    );
  }
}
