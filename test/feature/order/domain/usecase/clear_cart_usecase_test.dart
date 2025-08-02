import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/clear_cart_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'mock_repository.dart'; // Adjust the import path as needed

void main() {
  // 1. Declare variables
  late MockCartRepository mockCartRepository;
  late ClearCartUseCase usecase;

  setUp(() {
    // 2. Instantiate mocks and the usecase before each test
    mockCartRepository = MockCartRepository();
    usecase = ClearCartUseCase(cartRepository: mockCartRepository);
  });

  group('ClearCartUseCase', () {
    test(
      'should call clearCart on the repository and return Right(unit) on success',
      () async {
        // Arrange
        // Stub the repository method to return a successful void result (Right with unit)
        when(
          () => mockCartRepository.clearCart(),
        ).thenAnswer((_) async => const Right(unit));

        // Act
        // Call the usecase. No parameters are needed.
        final result = await usecase();

        // Assert
        // Expect the result to be a successful Right(unit)
        expect(result, const Right(unit));
        // Verify that the repository's clearCart method was called exactly once
        verify(() => mockCartRepository.clearCart()).called(1);
        // Ensure no other methods on the repository were called
        verifyNoMoreInteractions(mockCartRepository);
      },
    );

    test(
      'should return a Failure when the call to the repository is unsuccessful',
      () async {
        // Arrange
        // Define a failure object to be returned by the mock
        final tFailure = ApiFailure(message: "Failed to clear the cart");
        // Stub the repository method to return a failure (Left)
        when(
          () => mockCartRepository.clearCart(),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase();

        // Assert
        // Expect the result to be the defined Failure
        expect(result, Left(tFailure));
        // Verify that the repository's clearCart method was still called
        verify(() => mockCartRepository.clearCart()).called(1);
        // Ensure no other interactions
        verifyNoMoreInteractions(mockCartRepository);
      },
    );
  });
}
