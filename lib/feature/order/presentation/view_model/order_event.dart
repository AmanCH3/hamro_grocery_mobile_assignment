import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

/// Event to create a new order.
class CreateOrder extends OrderEvent {
  final List<OrderItem> items;
  final String address;
  final String phone;
  final bool applyDiscount;

  const CreateOrder({
    required this.items,
    required this.address,
    required this.phone,
    required this.applyDiscount,
  });

  @override
  List<Object?> get props => [items, address, phone, applyDiscount];
}

/// Event to fetch the orders for the currently logged-in user.
class GetMyOrders extends OrderEvent {}

/// Event to fetch the details of a single order.
class GetOrderById extends OrderEvent {
  final String orderId;

  const GetOrderById(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

/// Event to update the status of an order.
class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final OrderStatus newStatus;

  const UpdateOrderStatus({required this.orderId, required this.newStatus});

  @override
  List<Object?> get props => [orderId, newStatus];
}

/// Event to fetch the user's payment history.
class GetPaymentHistory extends OrderEvent {}
