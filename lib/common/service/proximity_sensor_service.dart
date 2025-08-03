// // lib/sensors/proximity_sensor_service.dart

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:proximity_sensor/proximity_sensor.dart';

// class ProximitySensorService {
//   static final ProximitySensorService _instance =
//       ProximitySensorService._internal();
//   factory ProximitySensorService() => _instance;
//   ProximitySensorService._internal();

//   StreamSubscription<int>? _proximitySubscription;
//   bool _isNear = false;
//   bool _isEnabled = false;
//   BuildContext? _context;
//   Timer? _warningTimer;
//   int _nearDuration = 0;

//   // Configuration - Increased sensitivity
//   static const int _warningThreshold = 1; // Reduced from 3 to 1 second
//   static const int _criticalThreshold = 3; // Reduced from 10 to 3 seconds
//   static const double _checkInterval =
//       0.5; // Reduced from 1.0 to 0.5 seconds for more sensitivity

//   // Sensitivity settings
//   static const double _highSensitivityThreshold = 0.2; // Very sensitive
//   static const double _mediumSensitivityThreshold = 0.5; // Medium sensitive
//   static const double _lowSensitivityThreshold = 1.0; // Less sensitive

//   double _currentSensitivity =
//       _highSensitivityThreshold; // Default to high sensitivity

//   // Callbacks
//   Function(bool)? _onProximityChanged;
//   Function(String)? _onWarning;
//   Function()? _onExitRequested; // New callback for exit requests

//   Future<bool> initialize(BuildContext context) async {
//     try {
//       _context = context;

//       bool isAvailable = false;
//       try {
//         final testSubscription = ProximitySensor.events.listen((event) {});
//         await testSubscription.cancel();
//         isAvailable = true;
//       } catch (e) {
//         debugPrint('Proximity sensor is not available on this device: $e');
//         return false;
//       }

//       _isEnabled = true;
//       _startListening();
//       return true;
//     } catch (e) {
//       debugPrint('Failed to initialize proximity sensor: $e');
//       return false;
//     }
//   }

//   void _startListening() {
//     if (!_isEnabled) return;

//     _proximitySubscription = ProximitySensor.events.listen(
//       (int event) {
//         final wasNear = _isNear;
//         _isNear = (event > 0);

//         if (_isNear != wasNear) {
//           _onProximityChanged?.call(_isNear);
//           _handleProximityChange();
//         }
//       },
//       onError: (error) {
//         debugPrint('Proximity sensor error: $error');
//       },
//     );
//   }

//   void _handleProximityChange() {
//     if (_isNear) {
//       _startWarningTimer();
//       _showProximityWarning();
//     } else {
//       _stopWarningTimer();
//       _nearDuration = 0;
//       _hideProximityWarning();
//     }
//   }

//   void _startWarningTimer() {
//     _warningTimer?.cancel();
//     _warningTimer = Timer.periodic(
//       Duration(milliseconds: (_checkInterval * 1000).round()),
//       (timer) {
//         _nearDuration++;
//         _checkWarningThresholds();
//       },
//     );
//   }

//   void _stopWarningTimer() {
//     _warningTimer?.cancel();
//     _warningTimer = null;
//   }

//   void _checkWarningThresholds() {
//     final sensitivityThreshold = (_currentSensitivity * 2).round();

//     if (_nearDuration == sensitivityThreshold) {
//       _showWarningMessage(
//         '⚠️ Device too close! Please move your device away.',
//         Colors.orange,
//       );
//     } else if (_nearDuration == _criticalThreshold) {
//       _showWarningMessage(
//         '🚨 Critical Warning! Prolonged close usage may cause eye strain.',
//         Colors.red,
//       );
//       _onExitRequested?.call();
//     } else if (_nearDuration > _criticalThreshold && _nearDuration % 2 == 0) {
//       _showWarningMessage(
//         'Consider taking a break and moving your device further away.',
//         Colors.red,
//       );
//       _onExitRequested?.call();
//     }
//   }

//   void _showProximityWarning() {
//     if (_context == null) return;
//     _onWarning?.call('Device detected near face');
//     _showAppSnackBar(
//       message: '📱 Device proximity detected',
//       icon: Icons.visibility_off,
//       backgroundColor: Colors.blue[700],
//       duration: const Duration(seconds: 2),
//     );
//   }

//   void _hideProximityWarning() {
//     if (_context == null) return;
//     _onWarning?.call('Device moved away');
//     _showAppSnackBar(
//       message: '✅ Safe distance maintained',
//       icon: Icons.visibility,
//       backgroundColor: Colors.green[700],
//       duration: const Duration(seconds: 2),
//     );
//   }

//   void _showWarningMessage(String message, Color color) {
//     if (_context == null) return;
//     _onWarning?.call(message);
//     _showAppSnackBar(
//       message: message,
//       icon: Icons.warning,
//       backgroundColor: color,
//       duration: const Duration(seconds: 4),
//     );
//   }

//   // MODIFIED METHOD: Uses standard SnackBar
//   void _showAppSnackBar({
//     required String message,
//     required IconData icon,
//     Color? backgroundColor,
//     required Duration duration,
//   }) {
//     if (_context == null || !Navigator.of(_context!).canPop()) {
//       // Hides any previous snackbar
//       ScaffoldMessenger.of(_context!).hideCurrentSnackBar();
//     }
//     ScaffoldMessenger.of(_context!).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(icon, color: Colors.white),
//             const SizedBox(width: 12),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: backgroundColor,
//         duration: duration,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void setCallbacks({
//     Function(bool)? onProximityChanged,
//     Function(String)? onWarning,
//     Function()? onExitRequested,
//   }) {
//     _onProximityChanged = onProximityChanged;
//     _onWarning = onWarning;
//     _onExitRequested = onExitRequested;
//   }

//   void setSensitivity(String level) {
//     switch (level.toLowerCase()) {
//       case 'high':
//         _currentSensitivity = _highSensitivityThreshold;
//         break;
//       case 'medium':
//         _currentSensitivity = _mediumSensitivityThreshold;
//         break;
//       case 'low':
//         _currentSensitivity = _lowSensitivityThreshold;
//         break;
//       default:
//         _currentSensitivity = _highSensitivityThreshold;
//     }
//     debugPrint(
//       'Proximity sensor sensitivity set to: $level (${_currentSensitivity}s)',
//     );
//   }

//   bool get isNear => _isNear;

//   void pause() {
//     _stopWarningTimer();
//     _proximitySubscription?.pause();
//   }

//   void resume() {
//     if (_isEnabled) {
//       _proximitySubscription?.resume();
//       if (_isNear) {
//         _startWarningTimer();
//       }
//     }
//   }

//   void dispose() {
//     _stopWarningTimer();
//     _proximitySubscription?.cancel();
//     _proximitySubscription = null;
//     _context = null;
//     _isEnabled = false;
//   }
// }
