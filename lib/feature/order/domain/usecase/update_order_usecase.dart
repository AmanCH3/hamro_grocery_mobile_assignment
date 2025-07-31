import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/repository/order_repository.dart';

class UpdateOrderStatusUseCase
    implements UseCaseWithParams<OrderEntity, UpdateOrderStatusParams> {
  final IOrderRepository _repository;

  UpdateOrderStatusUseCase({required IOrderRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, OrderEntity>> call(
    UpdateOrderStatusParams params,
  ) async {
    return await _repository.updateOrderStatus(
      orderId: params.orderId,
      status: params.status,
    );
  }
}

class UpdateOrderStatusParams extends Equatable {
  final String orderId;
  final OrderStatus status;

  const UpdateOrderStatusParams({required this.orderId, required this.status});

  @override
  List<Object?> get props => [orderId, status];
}
