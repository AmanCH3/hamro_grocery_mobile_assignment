class ApiEndpoints {
  ApiEndpoints._();

  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  static const String serverAddress = "http://192.168.1.14:8081";

  static const String baseUrl = "$serverAddress/api/";
  static const String imageUrl = "$serverAddress/uploads/";

  static const String imageUrll = "$serverAddress/images/";

  static const String login = "auth/login";
  static const String register = "auth/register";

  static const String getAllCategories = "categories/";

  static const String getAllProducts = "products/";
  static String getProductsByCategory(String categoryName) =>
      'products/category/$categoryName';

  // User Profile Endpoints
  static const String getUserProfile = "auth/profile";
  static const String updateUserProfile = "auth/profile";
  static const String updateUserProfilePicture = "auth/profile/picture";
  static const String forgotPassword = "auth/forgot-password";
  static const String resetPassword = "auth/reset-password/:token";

  static const String orders = "orders";
  static const String myOrders = "orders/myorders";
  static const String paymentHistory = "orders/payment-history";

  static const String khaltiInitiate = '/khalti/initiate';
  static const String khaltiVerify = '/khalti/verify';

  // ====================== Notification Routes ======================
  static const String notifications = "notifications";
  static const String markNotificationsAsRead = "notifications/mark-read";

  static const String chatQuery = "/chat";
}
