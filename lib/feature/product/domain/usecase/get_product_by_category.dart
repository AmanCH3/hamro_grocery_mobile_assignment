import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/entity/product_entity.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/repository/product_repository.dart';

// Usecase that takes a String parameter
class GetProductsByCategoryUsecase
    implements UseCaseWithParams<List<ProductEntity>, String> {
  final IProductRepository _productRepository;

  GetProductsByCategoryUsecase({required IProductRepository productRepository})
    : _productRepository = productRepository;

  @override
  Future<Either<Failure, List<ProductEntity>>> call(String params) async {
    return await _productRepository.getProductsByCategory(params);
  }
}
