import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/repository/cart_repository.dart';

/// Use case responsible for fetching all items from the cart.
class GetCartItemsUseCase implements UseCaseWithoutParams<List<OrderItem>> {
  final ICartRepository _cartRepository;

  GetCartItemsUseCase({required ICartRepository cartRepository})
    : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, List<OrderItem>>> call() async {
    return await _cartRepository.getCartItems();
  }
}
