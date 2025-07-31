import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/data/data_source/payment_datasource.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/payment_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/repository/payment_repository.dart';

class PaymentRepositoryImpl implements IPaymentRepository {
  final IPaymentDataSource _dataSource;
  PaymentRepositoryImpl({required IPaymentDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<Either<Failure, PaymentInitiationEntity>> initiateKhaltiPayment({
    required List<OrderItem> items,
    required String address,
    required String phone,
    required bool applyDiscount,
    String? token,
  }) async {
    try {
      final model = await _dataSource.initiateKhaltiPayment(
        items: items,
        address: address,
        phone: phone,
        applyDiscount: applyDiscount,
        token: token,
      );
      return Right(model.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyKhaltiPayment({
    required String pidx,
    String? token,
  }) async {
    try {
      await _dataSource.verifyKhaltiPayment(pidx: pidx, token: token);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
