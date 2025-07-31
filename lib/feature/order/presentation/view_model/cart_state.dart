import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  final CartStatus status;
  final Map<String, OrderItem> cartItems;
  final String? errorMessage;

  const CartState({
    required this.status,
    required this.cartItems,
    this.errorMessage,
  });

  factory CartState.initial() {
    return const CartState(status: CartStatus.initial, cartItems: {});
  }

  double get totalPrice {
    if (cartItems.isEmpty) return 0.0;
    return cartItems.values
        .map((item) => item.price * item.quantity)
        .reduce((sum, price) => sum + price);
  }

  int get totalItemCount {
    if (cartItems.isEmpty) return 0;
    return cartItems.values
        .map((item) => item.quantity)
        .reduce((sum, quantity) => sum + quantity);
  }

  CartState copyWith({
    CartStatus? status,
    Map<String, OrderItem>? cartItems,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      cartItems: cartItems ?? this.cartItems,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, cartItems, errorMessage];
}
