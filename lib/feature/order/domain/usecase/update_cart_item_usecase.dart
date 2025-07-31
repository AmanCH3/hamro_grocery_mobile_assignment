import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/repository/cart_repository.dart';

class UpdateCartItemQuantityUseCase
    implements UseCaseWithParams<void, UpdateCartItemParams> {
  final ICartRepository _cartRepository;

  UpdateCartItemQuantityUseCase({required ICartRepository cartRepository})
    : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, void>> call(UpdateCartItemParams params) async {
    return await _cartRepository.updateItemQuantity(
      params.id,
      params.newQuantity,
    );
  }
}

class UpdateCartItemParams extends Equatable {
  final String id;
  final int newQuantity;

  const UpdateCartItemParams({required this.id, required this.newQuantity});

  @override
  List<Object?> get props => [id, newQuantity];
}
