import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/app/shared_pref/token_shared_pref.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';

class UserLogoutUseCase implements UseCaseWithoutParams<void> {
  final TokenSharedPrefs _tokenSharedPrefs;

  UserLogoutUseCase({required TokenSharedPrefs tokenSharedPrefs})
    : _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call() async {
    return await _tokenSharedPrefs.clearToken();
  }
}
