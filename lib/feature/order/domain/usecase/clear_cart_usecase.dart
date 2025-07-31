import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/repository/cart_repository.dart';

class ClearCartUseCase implements UseCaseWithoutParams<void> {
  final ICartRepository _cartRepository;

  ClearCartUseCase({required ICartRepository cartRepository})
    : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, void>> call() async {
    return await _cartRepository.clearCart();
  }
}
