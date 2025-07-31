import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/payment_entity.dart';

abstract interface class IPaymentRepository {
  Future<Either<Failure, PaymentInitiationEntity>> initiateKhaltiPayment({
    required List<OrderItem> items,
    required String address,
    required String phone,
    required bool applyDiscount,
    String? token,
  });

  Future<Either<Failure, void>> verifyKhaltiPayment({
    required String pidx,
    String? token,
  });
}
