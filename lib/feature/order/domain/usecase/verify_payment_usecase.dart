import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/app/shared_pref/token_shared_pref.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/repository/payment_repository.dart';

class VerifyKhaltiPaymentUseCase implements UseCaseWithParams<void, String> {
  final IPaymentRepository _repository;
  final TokenSharedPrefs _tokenSharedPrefs;

  VerifyKhaltiPaymentUseCase(this._repository, this._tokenSharedPrefs);

  @override
  Future<Either<Failure, void>> call(String pidx) async {
    final tokenEither = await _tokenSharedPrefs.getToken();

    return tokenEither.fold(
      // Left side: Handle failure to get the token
      (failure) => Left(failure),
      // Right side: Handle success
      (token) async {
        // 'token' is now a String?, which is what the repository expects
        return await _repository.verifyKhaltiPayment(pidx: pidx, token: token);
      },
    );
  }
}
