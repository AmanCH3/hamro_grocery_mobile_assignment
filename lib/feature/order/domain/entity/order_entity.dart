import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/entity/auth_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';

enum OrderStatus {
  Pending,
  Processing,
  Shipped,
  Delivered,
  Cancelled,
  PendingPayment,
}

class OrderEntity extends Equatable {
  final String id;
  final String customerId ;
  final List<OrderItem> items;
  final double amount;
  final String address;
  final String phone;
  final String paymentMethod;
  final OrderStatus status;
  final bool discountApplied;
  final int pointsAwarded;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.customerId,
    required this.items,
    required this.amount,
    required this.address,
    required this.phone,
    required this.paymentMethod,
    required this.status,
    required this.discountApplied,
    required this.pointsAwarded,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, customerId, items, amount, address, phone, status];
}
