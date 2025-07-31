import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/add_cart_item_usecase.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/clear_cart_usecase.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/get_cart_item_usecase.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/remote_cart_item_usecase.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/update_cart_item_usecase.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/cart_event.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItemsUseCase _getCartItemsUseCase;
  final AddItemToCartUseCase _addItemToCartUseCase;
  final UpdateCartItemQuantityUseCase _updateCartItemQuantityUseCase;
  final RemoveItemFromCartUseCase _removeItemFromCartUseCase;
  final ClearCartUseCase _clearCartUseCase;

  CartBloc({
    required GetCartItemsUseCase getCartItemsUseCase,
    required AddItemToCartUseCase addItemToCartUseCase,
    required UpdateCartItemQuantityUseCase updateCartItemQuantityUseCase,
    required RemoveItemFromCartUseCase removeItemFromCartUseCase,
    required ClearCartUseCase clearCartUseCase,
  }) : _getCartItemsUseCase = getCartItemsUseCase,
       _addItemToCartUseCase = addItemToCartUseCase,
       _updateCartItemQuantityUseCase = updateCartItemQuantityUseCase,
       _removeItemFromCartUseCase = removeItemFromCartUseCase,
       _clearCartUseCase = clearCartUseCase,
       super(CartState.initial()) {
    // --- Register Event Handlers ---
    on<LoadCart>(_onLoadCart);
    on<AddItemToCart>(_onAddItemToCart);
    on<IncrementCartItem>(_onIncrementCartItem);
    on<DecrementCartItem>(_onDecrementCartItem);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<ClearCart>(_onClearCart);

    // Trigger the initial load when the BLoC is created.
    add(LoadCart());
  }

  // --- Event Handler Implementations ---

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await _getCartItemsUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (items) {
        final cartMap = {for (var item in items) item.productId: item};
        emit(state.copyWith(status: CartStatus.success, cartItems: cartMap));
      },
    );
  }

  Future<void> _onAddItemToCart(
    AddItemToCart event,
    Emitter<CartState> emit,
  ) async {
    final bool alreadyInCart = state.cartItems.containsKey(
      event.item.productId,
    );
    int newQuantity;
    OrderItem itemToAdd;

    if (alreadyInCart) {
      final existingItem = state.cartItems[event.item.productId]!;
      newQuantity = existingItem.quantity + 1;
      itemToAdd = existingItem.copyWith(
        quantity: newQuantity,
      ); // Create an updated item
    } else {
      newQuantity = 1; // It's a new item, quantity is 1
      itemToAdd = event.item;
    }

    final newCartItems = Map<String, OrderItem>.from(state.cartItems);
    newCartItems[event.item.productId] = itemToAdd;

    emit(
      state.copyWith(
        status: CartStatus.loading, // Show loading indicator
        cartItems: newCartItems, // But use the NEW map
      ),
    );

    if (alreadyInCart) {
      final result = await _updateCartItemQuantityUseCase(
        UpdateCartItemParams(
          id: event.item.productId,
          newQuantity: newQuantity,
        ),
      );
      result.fold((failure) => add(LoadCart()), (_) => add(LoadCart()));
    } else {
      final result = await _addItemToCartUseCase(event.item);
      result.fold((failure) => add(LoadCart()), (_) => add(LoadCart()));
    }
  }

  Future<void> _onIncrementCartItem(
    IncrementCartItem event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.loading));
    final currentQuantity = state.cartItems[event.id]?.quantity ?? 0;
    final result = await _updateCartItemQuantityUseCase(
      UpdateCartItemParams(id: event.id, newQuantity: currentQuantity + 1),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => add(LoadCart()),
    );
  }

  Future<void> _onDecrementCartItem(
    DecrementCartItem event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.loading));
    final currentQuantity = state.cartItems[event.id]?.quantity ?? 1;

    if (currentQuantity > 1) {
      final result = await _updateCartItemQuantityUseCase(
        UpdateCartItemParams(id: event.id, newQuantity: currentQuantity - 1),
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: CartStatus.failure,
            errorMessage: failure.message,
          ),
        ),
        (_) => add(LoadCart()),
      );
    } else {
      // If quantity is 1, decrementing means removing the item.
      final result = await _removeItemFromCartUseCase(event.id);
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: CartStatus.failure,
            errorMessage: failure.message,
          ),
        ),
        (_) => add(LoadCart()),
      );
    }
  }

  Future<void> _onRemoveItemFromCart(
    RemoveItemFromCart event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await _removeItemFromCartUseCase(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => add(LoadCart()),
    );
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await _clearCartUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => add(LoadCart()),
    );
  }
}
