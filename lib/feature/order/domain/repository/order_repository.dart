import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';

abstract class IOrderRepository {
  Future<Either<Failure, OrderEntity>> createOrder({
    required List<OrderItem> items,
    required String address,
    required String phone,
    required bool applyDiscount,
    String? token,
  });

  Future<Either<Failure, OrderEntity>> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  });

  Future<Either<Failure, List<OrderEntity>>> getMyOrders(String? token);
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId);
  Future<Either<Failure, List<OrderEntity>>> getPaymentHistory();
}
