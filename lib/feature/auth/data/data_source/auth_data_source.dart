import 'package:hamro_grocery_mobile/feature/auth/domain/entity/auth_entity.dart';

abstract interface class IAuthDataSource {
  Future<void> loginUser(String email, String password);
  Future<void> registerUser(AuthEntity entity);

  // profile
  Future<AuthEntity> getUserProfile(String? token);
  Future<void> updateUserProfile(AuthEntity entity, String? token);
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<void> resetPassword(String email);
  Future<void> logoutUser();
  Future<AuthEntity> updateProfilePicture(String imagePath, String? token);
}
