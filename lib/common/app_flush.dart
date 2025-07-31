import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class AppFlushbar {
  static Future<void> show({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required Icon icon,
    Duration duration = const Duration(seconds: 2),
  }) {
    return Flushbar(
      message: message,
      messageColor: Colors.white,
      backgroundColor: backgroundColor,
      duration: duration,
      borderRadius: BorderRadius.circular(15),
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(20),
      flushbarPosition: FlushbarPosition.BOTTOM,
      animationDuration: const Duration(milliseconds: 800),
      forwardAnimationCurve: Curves.bounceInOut,
      icon: icon,
    ).show(context);
  }
}