import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
// Import the CategoryEntity
import 'package:hamro_grocery_mobile/feature/category/domain/entity/category_entity.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/entity/product_entity.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/usecase/get_product_by_category.dart';
import 'package:mocktail/mocktail.dart';

import '../mock_repository.dart';

void main() {
  late MockProductRepository mockProductRepository;
  late GetProductsByCategoryUsecase getProductsByCategoryUsecase;

  setUp(() {
    mockProductRepository = MockProductRepository();
    getProductsByCategoryUsecase = GetProductsByCategoryUsecase(
      productRepository: mockProductRepository,
    );
  });

  // --- Corrected Test Data ---

  // 1. Define a category ID string to pass to the usecase.
  const tCategoryId = 'fruits_cat_id';

  // 2. Define a CategoryEntity object to use inside the ProductEntity.
  const tCategoryEntity = CategoryEntity(
    categoryId: tCategoryId,
    name: 'Fruits',
  );

  // 3. Define the product list with the correct field names and types.
  final tProductList = [
    const ProductEntity(
      productId: '3',
      name: 'Apple',
      price: 150,
      imageUrl: '',
      // Use the CategoryEntity object
      category: tCategoryEntity,
    ),
    const ProductEntity(
      // Use 'productId' instead of 'id'
      productId: '4',
      name: 'Banana',
      price: 100,
      imageUrl: '',
      // Use the CategoryEntity object
      category: tCategoryEntity,
    ),
  ];
  // --- End of Corrected Test Data ---

  test(
    'should get a list of products for a given category from the repository',
    () async {
      // Arrange
      // Stub the repository method to return a successful result (Right)
      when(
        // Pass the category ID string to the mock
        () => mockProductRepository.getProductsByCategory(tCategoryId),
      ).thenAnswer((_) async => Right(tProductList));

      // Act
      // Call the usecase with the category ID string
      final result = await getProductsByCategoryUsecase(tCategoryId);

      // Assert
      // Check that the result is the expected list of products
      expect(result, Right(tProductList));
      // Verify that the repository method was called exactly once with the correct parameter
      verify(
        () => mockProductRepository.getProductsByCategory(tCategoryId),
      ).called(1);
      // Ensure no other methods on the repository were called
      verifyNoMoreInteractions(mockProductRepository);
    },
  );

  test(
    'should return a Failure when the call to the repository is unsuccessful',
    () async {
      // Arrange
      final tFailure = ApiFailure(message: "An error occurred");
      // Stub the repository method to return a failure (Left)
      when(
        () => mockProductRepository.getProductsByCategory(tCategoryId),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await getProductsByCategoryUsecase(tCategoryId);

      // Assert
      expect(result, Left(tFailure));
      verify(
        () => mockProductRepository.getProductsByCategory(tCategoryId),
      ).called(1);
      verifyNoMoreInteractions(mockProductRepository);
    },
  );
}
