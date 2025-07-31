import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/data/data_source/cart_data_source.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/repository/cart_repository.dart';

class CartRepositoryImpl implements ICartRepository {
  final ICartDataSource _cartDataSource;

  CartRepositoryImpl({required ICartDataSource cartDataSource})
    : _cartDataSource = cartDataSource;

  @override
  Future<Either<Failure, List<OrderItem>>> getCartItems() async {
    try {
      final items = await _cartDataSource.getCartItems();
      return Right(items);
    } catch (e) {
      return Left(ApiFailure(message: 'Failed to load cart: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> addItem(OrderItem item) async {
    try {
      await _cartDataSource.addItem(item);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: 'Failed to add item: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateItemQuantity(
    String id,
    int newQuantity,
  ) async {
    try {
      await _cartDataSource.updateItemQuantity(id, newQuantity);
      return const Right(null);
    } catch (e) {
      return Left(
        ApiFailure(message: 'Failed to update quantity: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> removeItem(String id) async {
    try {
      await _cartDataSource.removeItem(id);
      return const Right(null);
    } catch (e) {
      return Left(
        ApiFailure(message: 'Failed to remove item: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await _cartDataSource.clearCart();
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: 'Failed to clear cart: ${e.toString()}'));
    }
  }
}
