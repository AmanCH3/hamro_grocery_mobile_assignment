import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/repository/cart_repository.dart';

class RemoveItemFromCartUseCase implements UseCaseWithParams<void, String> {
  final ICartRepository _cartRepository;

  RemoveItemFromCartUseCase({required ICartRepository cartRepository})
    : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await _cartRepository.removeItem(id);
  }
}
