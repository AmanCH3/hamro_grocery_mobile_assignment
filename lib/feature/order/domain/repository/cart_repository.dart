import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';

abstract class ICartRepository {
  Future<Either<Failure, List<OrderItem>>> getCartItems();
  Future<Either<Failure, void>> addItem(OrderItem item);
  Future<Either<Failure, void>> removeItem(String id);
  Future<Either<Failure, void>> updateItemQuantity(String id, int newQuantity);
  Future<Either<Failure, void>> clearCart();
}
