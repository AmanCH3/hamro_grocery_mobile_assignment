import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/entity/auth_entity.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/repository/auth_repository.dart';

class UpdateProfilePictureUsecase
    implements UseCaseWithParams<AuthEntity, File> {
  final IAuthRepository authRepository;

  UpdateProfilePictureUsecase({required this.authRepository});

  @override
  Future<Either<Failure, AuthEntity>> call(File imageFile) async {
    // This correctly calls the repository method with the file's path.
    return await authRepository.updateProfilePicture(imageFile.path);
  }
}
