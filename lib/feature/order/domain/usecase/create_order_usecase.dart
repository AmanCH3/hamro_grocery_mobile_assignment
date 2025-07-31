import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:hamro_grocery_mobile/app/shared_pref/token_shared_pref.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/repository/order_repository.dart';

class CreateOrderUseCase
    implements UseCaseWithParams<OrderEntity, CreateOrderParams> {
  final IOrderRepository _repository;
  final TokenSharedPrefs _tokenSharedPref;

  CreateOrderUseCase({
    required IOrderRepository repository,
    required TokenSharedPrefs tokenSharedPref,
  }) : _repository = repository,
       _tokenSharedPref = tokenSharedPref;

  @override
  Future<Either<Failure, OrderEntity>> call(CreateOrderParams params) async {
    final token = await _tokenSharedPref.getToken();
    return token.fold(
      (failure) {
        return Left(failure);
      },
      (token) async {
        return await _repository.createOrder(
          items: params.items,
          address: params.address,
          phone: params.phone,
          applyDiscount: params.applyDiscount,
          token: token,
        );
      },
    );
  }
}

class CreateOrderParams extends Equatable {
  final List<OrderItem> items;
  final String address;
  final String phone;
  final bool applyDiscount;

  const CreateOrderParams({
    required this.items,
    required this.address,
    required this.phone,
    required this.applyDiscount,
  });

  @override
  List<Object?> get props => [items, address, phone, applyDiscount];
}
