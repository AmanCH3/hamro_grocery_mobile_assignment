import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/update_cart_item_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_repository.dart';

void main() {
  // 1. Declare variables
  late MockCartRepository mockCartRepository;
  late UpdateCartItemQuantityUseCase usecase;

  setUp(() {
    // 2. Instantiate mocks and the usecase before each test
    mockCartRepository = MockCartRepository();
    usecase = UpdateCartItemQuantityUseCase(cartRepository: mockCartRepository);
  });

  // 3. Prepare reusable test data
  const tParams = UpdateCartItemParams(id: 'prod_123', newQuantity: 5);
  final tFailure = ApiFailure(message: 'Could not update item quantity');

  group('UpdateCartItemQuantityUseCase', () {
    test(
      'should call updateItemQuantity on the repository and return Right(unit) on success',
      () async {
        // Arrange
        // Stub the repository method to return a successful void result (Right with unit)
        // Ensure the parameters passed to the mock match the test data
        when(
          () => mockCartRepository.updateItemQuantity(
            tParams.id,
            tParams.newQuantity,
          ),
        ).thenAnswer((_) async => const Right(unit));

        // Act
        // Call the usecase with the parameters object
        final result = await usecase(tParams);

        // Assert
        // Expect the result to be a successful Right(unit)
        expect(result, const Right(unit));
        // Verify that the repository's method was called exactly once with the correct, unpacked parameters
        verify(
          () => mockCartRepository.updateItemQuantity(
            tParams.id,
            tParams.newQuantity,
          ),
        ).called(1);
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
          () => mockCartRepository.updateItemQuantity(
            tParams.id,
            tParams.newQuantity,
          ),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase(tParams);

        // Assert
        // Expect the result to be the defined Failure
        expect(result, Left(tFailure));
        // Verify that the repository's method was still called with the correct parameters
        verify(
          () => mockCartRepository.updateItemQuantity(
            tParams.id,
            tParams.newQuantity,
          ),
        ).called(1);
        // Ensure no other interactions
        verifyNoMoreInteractions(mockCartRepository);
      },
    );
  });
}
