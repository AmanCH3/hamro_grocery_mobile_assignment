import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/update_order_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_token_repository.dart';

void main() {
  // 1. Declare variables
  late MockOrderRepository mockOrderRepository;
  late UpdateOrderStatusUseCase usecase;

  setUp(() {
    // 2. Instantiate mocks and the usecase before each test
    mockOrderRepository = MockOrderRepository();
    usecase = UpdateOrderStatusUseCase(repository: mockOrderRepository);
  });

  // 3. Prepare reusable test data
  const tOrderId = 'order_xyz_789';
  const tNewStatus = OrderStatus.Processing;
  const tParams = UpdateOrderStatusParams(
    orderId: tOrderId,
    status: tNewStatus,
  );

  // An entity representing the order AFTER the update
  final tUpdatedOrderEntity = OrderEntity(
    id: tOrderId, // The ID should match the request
    status: tNewStatus, // The status should be the new one
    // Fill in other details for a complete entity object
    customerId: 'cust_abc',
    items: const [],
    amount: 100.0,
    address: '123 Test Ave',
    phone: '555-5555',
    paymentMethod: 'Credit Card',
    discountApplied: false,
    pointsAwarded: 10,
    createdAt: DateTime.now(),
  );

  final tFailure = ApiFailure(message: 'Failed to update order status');

  group('UpdateOrderStatusUseCase', () {
    test(
      'should call updateOrderStatus on the repository and return the updated OrderEntity on success',
      () async {
        // Arrange
        // Stub the repository method to return a successful result
        when(
          () => mockOrderRepository.updateOrderStatus(
            orderId: tParams.orderId,
            status: tParams.status,
          ),
        ).thenAnswer((_) async => Right(tUpdatedOrderEntity));

        // Act
        // Call the usecase with the parameters object
        final result = await usecase(tParams);

        // Assert
        // Expect the result to be the successful, updated entity
        expect(result, Right(tUpdatedOrderEntity));
        // Verify that the repository's method was called exactly once with the correct, unpacked parameters
        verify(
          () => mockOrderRepository.updateOrderStatus(
            orderId: tParams.orderId,
            status: tParams.status,
          ),
        ).called(1);
        // Ensure no other methods on the repository were called
        verifyNoMoreInteractions(mockOrderRepository);
      },
    );

    test(
      'should return a Failure when the call to the repository is unsuccessful',
      () async {
        // Arrange
        // Stub the repository method to return a failure
        when(
          () => mockOrderRepository.updateOrderStatus(
            orderId: tParams.orderId,
            status: tParams.status,
          ),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase(tParams);

        // Assert
        // Expect the result to be the defined Failure
        expect(result, Left(tFailure));
        // Verify that the repository's method was still called with the correct parameters
        verify(
          () => mockOrderRepository.updateOrderStatus(
            orderId: tParams.orderId,
            status: tParams.status,
          ),
        ).called(1);
        // Ensure no other interactions
        verifyNoMoreInteractions(mockOrderRepository);
      },
    );
  });
}
