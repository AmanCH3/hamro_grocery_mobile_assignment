import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/app/shared_pref/token_shared_pref.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';

// This use case has no parameters and returns a nullable String (the token).
class CheckAuthStatusUseCase implements UseCaseWithoutParams<String?> {
  final TokenSharedPrefs _tokenSharedPrefs;

  CheckAuthStatusUseCase({required TokenSharedPrefs tokenSharedPrefs})
    : _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, String?>> call() async {
    return await _tokenSharedPrefs.getToken();
  }
}
