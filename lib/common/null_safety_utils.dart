class NullSafetyUtils {
  /// Safely converts any value to string, handling null values
  static String safeToString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  /// Safely converts nullable int to string with default value
  static String intToString(int? value, {String defaultValue = '0'}) {
    return value?.toString() ?? defaultValue;
  }

  /// Safely converts nullable double to string with default value
  static String doubleToString(double? value, {String defaultValue = '0.0'}) {
    return value?.toString() ?? defaultValue;
  }

  /// Safely gets string value with fallback
  static String safeString(String? value, {String fallback = ''}) {
    return value ?? fallback;
  }

  /// Safely gets int value with fallback
  static int safeInt(int? value, {int fallback = 0}) {
    return value ?? fallback;
  }

  /// Safely gets double value with fallback
  static double safeDouble(double? value, {double fallback = 0.0}) {
    return value ?? fallback;
  }

  /// Checks if a string is null or empty
  static bool isNullOrEmpty(String? value) {
    return value == null || value.isEmpty;
  }

  /// Checks if a string is not null and not empty
  static bool isNotNullOrEmpty(String? value) {
    return value != null && value.isNotEmpty;
  }

  /// Safely formats a number for display
  static String formatNumber(dynamic value, {String defaultValue = '0'}) {
    if (value == null) return defaultValue;
    
    if (value is int) return value.toString();
    if (value is double) return value.toStringAsFixed(2);
    if (value is String) return value;
    
    return value.toString();
  }

  /// Safely creates a key for widgets
  static String createSafeKey(dynamic value, {String prefix = 'key'}) {
    return '$prefix${safeToString(value)}';
  }
} 