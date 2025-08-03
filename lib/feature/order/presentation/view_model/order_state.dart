import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_entity.dart';

/// Enum to represent the current status of an API request.
enum OrderRequestStatus { initial, loading, success, failure }

class OrderState extends Equatable {
  final OrderRequestStatus? status;
  final List<OrderEntity> myOrders;
  final OrderEntity? selectedOrder;
  final List<OrderEntity> paymentHistory;
  final String? errorMessage;

  const OrderState({
    this.status,
    this.myOrders = const [],
    this.selectedOrder,
    this.paymentHistory = const [],
    this.errorMessage,
  });

  factory OrderState.initial() {
    return const OrderState(status: OrderRequestStatus.initial);
  }

  OrderState copyWith({
    OrderRequestStatus? status,
    List<OrderEntity>? myOrders,
    OrderEntity? selectedOrder,
    List<OrderEntity>? paymentHistory,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      myOrders: myOrders ?? this.myOrders,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      paymentHistory: paymentHistory ?? this.paymentHistory,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    myOrders,
    selectedOrder,
    paymentHistory,
    errorMessage,
  ];
}
