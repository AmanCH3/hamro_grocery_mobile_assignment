import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/app/shared_pref/token_shared_pref.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/entity/auth_entity.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/repository/auth_repository.dart';

class UpdateProfilePictureUsecase
    implements UseCaseWithParams<AuthEntity, File> {
  final IAuthRepository authRepository;
  final TokenSharedPrefs tokenSharedPrefs;

  UpdateProfilePictureUsecase({
    required this.authRepository,
    required this.tokenSharedPrefs,
  });

  @override
  Future<Either<Failure, AuthEntity>> call(File imageFile) async {
    final tokenResult = await tokenSharedPrefs.getToken();
    return tokenResult.fold((failure) => Left(failure), (token) async {
      return await authRepository.updateProfilePicture(imageFile.path, token);
    });
  }
}
