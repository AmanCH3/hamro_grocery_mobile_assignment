import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/app/shared_pref/token_shared_pref.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/repository/auth_repository.dart';
class LoginParams extends Equatable {
  final String email;

  final String password;

  const LoginParams({required this.email, required this.password});

  @override

  List<Object?> get props => [email, password];
}

class UserLoginUseCase implements UseCaseWithParams<String, LoginParams> {
  final IAuthRepository _authRepository;
  final TokenSharedPrefs _tokenSharedPrefs ;

  UserLoginUseCase({required IAuthRepository authRepository , required TokenSharedPrefs tokenSharedPrefs})
    : _authRepository = authRepository ,
      _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    final result = await _authRepository.loginUser(
      params.email,
      params.password,
    );
    return result.fold((failure) => Left(failure), (token) async {
      await _tokenSharedPrefs.saveToken(token);
      return Right(token);
    });
  }
}