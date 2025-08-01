import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/product/data/data_source/product_data_source.dart';
import 'package:hamro_grocery_mobile/feature/product/data/data_source/remote_data_source/product_remote_data_source.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/entity/product_entity.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/repository/product_repository.dart';

class ProductRemoteRepository implements IProductRepository {
  final ProductRemoteDataSource _productDataSource;
  ProductRemoteRepository({
    required ProductRemoteDataSource productRemoteDataSource,
  }) : _productDataSource = productRemoteDataSource;

  @override
  Future<Either<Failure, List<ProductEntity>>> getAllProducts() async {
    try {
      final product = await _productDataSource.getAllProducts();
      return Right(product);
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
    String categoryName,
  ) async {
    try {
      final products = await _productDataSource.getProductsByCategory(
        categoryName,
      ); // Use correct method
      final productEntities = products.map((e) => e.toEntity()).toList();
      return Right(productEntities);
    } on ApiFailure {
      return Left(ApiFailure(message: 'Error'));
    }
  }
}
