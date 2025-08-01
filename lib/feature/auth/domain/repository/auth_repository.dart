import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/entity/auth_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, void>> registerUser(AuthEntity user);
  Future<Either<Failure, String>> loginUser(String email, String password);
  Future<Either<Failure, AuthEntity>> getUserProfile(String? token);
  Future<Either<Failure, void>> updateUserProfile(
    AuthEntity user,
    String? token,
  );
  Future<Either<Failure, void>> changePassword(
    String oldPassword,
    String newPassword,
  );
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, void>> logoutUser();
  Future<Either<Failure, AuthEntity>> updateProfilePicture(
    String imagePath,
    String? token,
  );
}
