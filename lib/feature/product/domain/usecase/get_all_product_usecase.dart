import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/entity/product_entity.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/repository/product_repository.dart';

class GetAllProductUsecase
    implements UseCaseWithoutParams<List<ProductEntity>> {
  final IProductRepository _productRepository;

  GetAllProductUsecase({required IProductRepository productRepository})
    : _productRepository = productRepository;

  @override
  Future<Either<Failure, List<ProductEntity>>> call() async {
    try {
      return _productRepository.getAllProducts();
    } catch (e) {
      return Left(
        ApiFailure(message: 'Failed to fetch products: $e', statusCode: 500),
      );
    }
  }
}
