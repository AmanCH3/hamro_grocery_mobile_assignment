import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/app/shared_pref/token_shared_pref.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/payment_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/repository/payment_repository.dart';

class InitiateKhaltiPaymentUseCase
    implements
        UseCaseWithParams<PaymentInitiationEntity, InitiatePaymentParams> {
  final IPaymentRepository _repository;
  final TokenSharedPrefs _tokenSharedPrefs;

  InitiateKhaltiPaymentUseCase(this._repository, this._tokenSharedPrefs);

  @override
  Future<Either<Failure, PaymentInitiationEntity>> call(
    InitiatePaymentParams params,
  ) async {
    // 1. Get the token, which is wrapped in an Either
    final tokenEither = await _tokenSharedPrefs.getToken();

    // 2. Use .fold() to handle both success and failure cases
    return tokenEither.fold(
      // Left side: This function runs if getToken() failed
      (failure) {
        return Left(failure); // Immediately return the failure
      },
      // Right side: This function runs if getToken() succeeded
      (token) async {
        // Now 'token' is a simple String?, which is what the repository needs
        return await _repository.initiateKhaltiPayment(
          items: params.items,
          address: params.address,
          phone: params.phone,
          applyDiscount: params.applyDiscount,
          token: token,
        );
      },
    );
  }
}

class InitiatePaymentParams {
  final List<OrderItem> items;
  final String address;
  final String phone;
  final bool applyDiscount;

  InitiatePaymentParams({
    required this.items,
    required this.address,
    required this.phone,
    required this.applyDiscount,
  });
}
