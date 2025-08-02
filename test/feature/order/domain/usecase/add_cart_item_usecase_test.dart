import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/add_cart_item_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_repository.dart';

void main() {
  // 1. Declare variables
  late MockCartRepository mockCartRepository;
  late AddItemToCartUseCase usecase;

  setUp(() {
    // 2. Instantiate mocks and the usecase before each test
    mockCartRepository = MockCartRepository();
    usecase = AddItemToCartUseCase(cartRepository: mockCartRepository);
  });

  // 3. Prepare test data
  // Assuming OrderItemEntity has these fields. Adjust if your entity is different.
  const tOrderItem = OrderItem(
    productId: 'prod_123',
    name: 'Test Product',
    price: 99.99,
    quantity: 2,
    imageUrl: 'image.png',
  );

  group('AddItemToCartUseCase', () {
    test(
      'should call addItem on the repository and return Right(unit) on success',
      () async {
        // Arrange
        // Stub the repository method to return a successful result (Right with unit for void)
        when(
          () => mockCartRepository.addItem(tOrderItem),
        ).thenAnswer((_) async => const Right(unit));

        // Act
        // Call the usecase with the test OrderItem
        final result = await usecase(tOrderItem);

        // Assert
        // Expect the result to be a successful Right(unit)
        expect(result, const Right(unit));
        // Verify that the repository's addItem method was called exactly once with the correct item
        verify(() => mockCartRepository.addItem(tOrderItem)).called(1);
        // Ensure no other methods on the repository were called
        verifyNoMoreInteractions(mockCartRepository);
      },
    );

    test(
      'should return a Failure when the call to the repository is unsuccessful',
      () async {
        // Arrange
        // Define a failure object to be returned by the mock
        final tFailure = ApiFailure(message: "Failed to add item to cart");
        // Stub the repository method to return a failure (Left)
        when(
          () => mockCartRepository.addItem(tOrderItem),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase(tOrderItem);

        // Assert
        // Expect the result to be the defined Failure
        expect(result, Left(tFailure));
        // Verify that the repository's addItem method was still called
        verify(() => mockCartRepository.addItem(tOrderItem)).called(1);
        // Ensure no other interactions
        verifyNoMoreInteractions(mockCartRepository);
      },
    );
  });
}
