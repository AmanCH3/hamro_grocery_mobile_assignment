import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/get_cart_item_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_repository.dart';

void main() {
  // 1. Declare variables
  late MockCartRepository mockCartRepository;
  late GetCartItemsUseCase usecase;

  setUp(() {
    // 2. Instantiate mocks and the usecase before each test
    mockCartRepository = MockCartRepository();
    usecase = GetCartItemsUseCase(cartRepository: mockCartRepository);
  });

  // 3. Prepare reusable test data
  final tCartItems = [
    const OrderItem(
      productId: '1',
      name: 'Apple',
      price: 1.5,
      quantity: 3,
      imageUrl: '...',
    ),
    const OrderItem(
      productId: '2',
      name: 'Bread',
      price: 2.5,
      quantity: 1,
      imageUrl: '...',
    ),
  ];
  final tFailure = ApiFailure(message: 'Could not retrieve items from cart');

  group('GetCartItemsUseCase', () {
    test(
      'should get a list of cart items from the repository successfully',
      () async {
        // Arrange
        // Stub the repository method to return a successful result
        when(
          () => mockCartRepository.getCartItems(),
        ).thenAnswer((_) async => Right(tCartItems));

        // Act
        // Call the usecase (no parameters needed)
        final result = await usecase();

        // Assert
        // Expect the result to be the successful list of items
        expect(result, Right(tCartItems));
        // Verify that the repository's getCartItems method was called exactly once
        verify(() => mockCartRepository.getCartItems()).called(1);
        // Ensure no other methods on the repository were called
        verifyNoMoreInteractions(mockCartRepository);
      },
    );

    test(
      'should return a Failure when the call to the repository is unsuccessful',
      () async {
        // Arrange
        // Stub the repository method to return a failure
        when(
          () => mockCartRepository.getCartItems(),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase();

        // Assert
        // Expect the result to be the defined Failure
        expect(result, Left(tFailure));
        // Verify that the repository's method was still called
        verify(() => mockCartRepository.getCartItems()).called(1);
        // Ensure no other interactions
        verifyNoMoreInteractions(mockCartRepository);
      },
    );
  });
}
