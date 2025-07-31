import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/category/data/data_source/remote_data_source/category_remote_data_source.dart';
import 'package:hamro_grocery_mobile/feature/category/domain/entity/category_entity.dart';
import 'package:hamro_grocery_mobile/feature/category/domain/repository/category_repository.dart';

class CategoryRemoteRepository implements ICategoryRepository {
  final CategoryRemoteDataSource _categoryRemoteDataSource;

  CategoryRemoteRepository({
    required CategoryRemoteDataSource categoryRemoteDataSource,
  }) : _categoryRemoteDataSource = categoryRemoteDataSource;
  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    try {
      final List<CategoryEntity> categories = await _categoryRemoteDataSource.getAllCategories();
      return Right(categories) ;
    } catch (e) {
      return Left(
        ApiFailure(message: 'Failed to fetch categories: $e', statusCode: 500),
      );
    }
  }
}
