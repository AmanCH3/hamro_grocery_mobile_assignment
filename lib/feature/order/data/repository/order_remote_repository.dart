import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/data/data_source/order_item_remote_data_source.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/repository/order_repository.dart';

class OrderRepositoryImpl implements IOrderRepository {
  final OrderRemoteDataSourceImpl _orderDataSource;

  OrderRepositoryImpl({required OrderRemoteDataSourceImpl orderDataSource})
    : _orderDataSource = orderDataSource;

  @override
  Future<Either<Failure, OrderEntity>> createOrder({
    required List<OrderItem> items,
    required String address,
    required String phone,
    required bool applyDiscount,
    String? token,
  }) async {
    try {
      final orderApiModel = await _orderDataSource.createOrder(
        items: items,
        address: address,
        phone: phone,
        applyDiscount: applyDiscount,
        token: token,
      );
      return Right(orderApiModel.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    try {
      // The data source already returns the entity, so we just wrap it in Right.
      final updatedOrder = await _orderDataSource.updateOrderStatus(
        orderId: orderId,
        status: status,
      );
      return Right(updatedOrder);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getMyOrders(String? token) async {
    try {
      final orders = await _orderDataSource.getMyOrders(token);
      return Right(orders);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId) async {
    try {
      final order = await _orderDataSource.getOrderById(orderId);
      return Right(order);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getPaymentHistory() async {
    try {
      final history = await _orderDataSource.getPaymentHistory();
      return Right(history);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
