import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load the initial cart items from storage.
class LoadCart extends CartEvent {}

/// Event triggered when a user wants to add an item to the cart.
class AddItemToCart extends CartEvent {
  final OrderItem item;

  const AddItemToCart(this.item);

  @override
  List<Object?> get props => [item];
}

class IncrementCartItem extends CartEvent {
  final String id;

  const IncrementCartItem(this.id);

  @override
  List<Object?> get props => [id];
}

class DecrementCartItem extends CartEvent {
  final String id;

  const DecrementCartItem(this.id);

  @override
  List<Object?> get props => [id];
}

class RemoveItemFromCart extends CartEvent {
  final String id;

  const RemoveItemFromCart(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to clear all items from the cart.
class ClearCart extends CartEvent {}
