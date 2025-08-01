import 'package:hamro_grocery_mobile/feature/auth/domain/entity/auth_entity.dart';

class ProfileUtils {
  /// Creates a complete AuthEntity for profile updates, ensuring all fields are included
  static AuthEntity createUpdateEntity({
    required AuthEntity currentEntity,
    String? newFullName,
    String? newLocation,
    String? newProfilePicture,
  }) {
    return AuthEntity(
      userId: currentEntity.userId,
      fullName: newFullName ?? currentEntity.fullName,
      email: currentEntity.email,
      password: currentEntity.password,
      profilePicture: newProfilePicture ?? currentEntity.profilePicture,
      location: newLocation ?? currentEntity.location,
      grocerypoints: currentEntity.grocerypoints,
    );
  }

  /// Validates that all required fields are present in the entity
  static bool isValidForUpdate(AuthEntity entity) {
    return entity.userId != null &&
           entity.fullName.isNotEmpty &&
           entity.email.isNotEmpty &&
           entity.password.isNotEmpty;
  }

  /// Logs the entity for debugging purposes
  static void logEntity(String prefix, AuthEntity entity) {
    print('$prefix - Entity Details:');
    print('  userId: ${entity.userId}');
    print('  fullName: ${entity.fullName}');
    print('  email: ${entity.email}');
    print('  password: ${entity.password.isNotEmpty ? '[HIDDEN]' : '[EMPTY]'}');
    print('  profilePicture: ${entity.profilePicture ?? 'null'}');
    print('  location: ${entity.location ?? 'null'}');
    print('  grocerypoints: ${entity.grocerypoints ?? 'null'}');
  }

  /// Checks if the profile picture has changed
  static bool hasProfilePictureChanged(AuthEntity oldEntity, AuthEntity newEntity) {
    return oldEntity.profilePicture != newEntity.profilePicture;
  }

  /// Gets a safe display name for the user
  static String getDisplayName(AuthEntity entity) {
    return entity.fullName.isNotEmpty ? entity.fullName : 'User';
  }

  /// Gets a safe location display
  static String getLocationDisplay(AuthEntity entity) {
    return entity.location?.isNotEmpty == true ? entity.location! : 'Location not set';
  }

  /// Gets a safe grocery points display
  static String getGroceryPointsDisplay(AuthEntity entity) {
    return entity.grocerypoints?.toString() ?? '0';
  }
} 