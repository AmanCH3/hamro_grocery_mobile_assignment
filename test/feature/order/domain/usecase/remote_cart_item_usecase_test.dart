import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/remote_cart_item_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_repository.dart';

void main() {
  // 1. Declare variables
  late MockCartRepository mockCartRepository;
  late RemoveItemFromCartUseCase usecase;

  setUp(() {
    // 2. Instantiate mocks and the usecase before each test
    mockCartRepository = MockCartRepository();
    usecase = RemoveItemFromCartUseCase(cartRepository: mockCartRepository);
  });

  // 3. Prepare reusable test data
  const tProductId = 'prod_123_to_remove';
  final tFailure = ApiFailure(message: 'Could not remove item from cart');

  group('RemoveItemFromCartUseCase', () {
    test(
      'should call removeItem on the repository and return Right(unit) on success',
      () async {
        // Arrange
        // Stub the repository method to return a successful void result (Right with unit)
        when(
          () => mockCartRepository.removeItem(tProductId),
        ).thenAnswer((_) async => const Right(unit));

        // Act
        // Call the usecase with the product ID to remove
        final result = await usecase(tProductId);

        // Assert
        // Expect the result to be a successful Right(unit)
        expect(result, const Right(unit));
        // Verify that the repository's removeItem method was called exactly once with the correct ID
        verify(() => mockCartRepository.removeItem(tProductId)).called(1);
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
          () => mockCartRepository.removeItem(tProductId),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase(tProductId);

        // Assert
        // Expect the result to be the defined Failure
        expect(result, Left(tFailure));
        // Verify that the repository's method was still called with the correct ID
        verify(() => mockCartRepository.removeItem(tProductId)).called(1);
        // Ensure no other interactions
        verifyNoMoreInteractions(mockCartRepository);
      },
    );
  });
}
