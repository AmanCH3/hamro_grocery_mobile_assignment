import 'package:hamro_grocery_mobile/feature/order/data/model/order_model_api.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';

abstract class IOrderDataSource {
  Future<OrderApiModel> createOrder({
    required List<OrderItem> items,
    required String address,
    required String phone,
    required bool applyDiscount,
    String? token,
  });

  Future<OrderEntity> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  });

  Future<List<OrderEntity>> getMyOrders(String? token);

  Future<OrderEntity> getOrderById(String orderId);

  /// Fetches the payment history for the current user.
  Future<List<OrderEntity>> getPaymentHistory();
}
