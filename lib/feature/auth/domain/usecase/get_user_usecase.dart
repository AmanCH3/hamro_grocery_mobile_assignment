import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/app/shared_pref/token_shared_pref.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/entity/auth_entity.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/repository/auth_repository.dart';

class GetUserUsecase implements UseCaseWithoutParams<AuthEntity> {
  final IAuthRepository _authRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  GetUserUsecase({
    required IAuthRepository authRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _authRepository = authRepository,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, AuthEntity>> call() async {
    final token = await _tokenSharedPrefs.getToken();
    return token.fold((failure) => Left(failure), (tokenValue) async {
      if (tokenValue == null || tokenValue.isEmpty) {
        return Left(ApiFailure(message: "No token found", statusCode: 403));
      }
      return await _authRepository.getUserProfile(tokenValue);
    });
  }
}
