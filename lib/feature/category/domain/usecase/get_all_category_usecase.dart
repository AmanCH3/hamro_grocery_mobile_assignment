import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/category/domain/entity/category_entity.dart';
import 'package:hamro_grocery_mobile/feature/category/domain/repository/category_repository.dart';

class GetAllCategoryUsecase
    implements UseCaseWithoutParams<List<CategoryEntity>> {
  final ICategoryRepository categoryRepository;

  GetAllCategoryUsecase({required this.categoryRepository});

  @override
  Future<Either<Failure, List<CategoryEntity>>> call() async {
    try {
      return categoryRepository.getAllCategories();
    } catch (e) {
      return Left(
        ApiFailure(message: 'Failed to fetch categories: $e', statusCode: 500),
      );
    }
  }
}
