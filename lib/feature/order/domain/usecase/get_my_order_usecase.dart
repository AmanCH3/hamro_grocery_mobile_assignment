import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/app/shared_pref/token_shared_pref.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/repository/order_repository.dart';

class GetMyOrdersUseCase implements UseCaseWithoutParams<List<OrderEntity>> {
  final IOrderRepository _repository;
  final TokenSharedPrefs _tokenSharedPrefs;

  GetMyOrdersUseCase({
    required IOrderRepository repository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _repository = repository,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, List<OrderEntity>>> call() async {
    final token = await _tokenSharedPrefs.getToken();
    return token.fold(
      (failure) => Left(failure),
      // If token fetching fails, return that failure
      (token) async => await _repository.getMyOrders(
        token,
      ), // If successful, call the repository
    );
  }
}
