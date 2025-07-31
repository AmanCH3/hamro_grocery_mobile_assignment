import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';

import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/repository/cart_repository.dart';

class AddItemToCartUseCase implements UseCaseWithParams<void, OrderItem> {
  final ICartRepository _cartRepository;

  AddItemToCartUseCase({required ICartRepository cartRepository})
    : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, void>> call(OrderItem item) async {
    return await _cartRepository.addItem(item);
  }
}
