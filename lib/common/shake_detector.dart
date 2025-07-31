import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetector {
  final void Function() onPhoneShake;
  final double shakeThreshold;
  final int minTimeBetweenShakes;

  StreamSubscription? _subscription;
  DateTime? _lastShakeTime;

  ShakeDetector({
    required this.onPhoneShake,
    this.shakeThreshold = 11.0,
    this.minTimeBetweenShakes = 1000,
  });

  void startListening() {
    _subscription = accelerometerEvents.listen((event) {
      final acceleration = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      final now = DateTime.now();

      if (acceleration > shakeThreshold) {
        if (_lastShakeTime == null ||
            now.difference(_lastShakeTime!) >
                Duration(milliseconds: minTimeBetweenShakes)) {
          _lastShakeTime = now;
          onPhoneShake();
        }
      }
    });
  }

  void stopListening() {
    _subscription?.cancel();
  }
}
