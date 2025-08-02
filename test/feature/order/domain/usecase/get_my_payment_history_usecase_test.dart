import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/get_my_payment_history_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_token_repository.dart';

void main() {
  // 1. Declare variables
  late MockOrderRepository mockOrderRepository;
  late GetPaymentHistoryUseCase usecase;

  setUp(() {
    // 2. Instantiate mocks and the usecase before each test
    mockOrderRepository = MockOrderRepository();
    usecase = GetPaymentHistoryUseCase(repository: mockOrderRepository);
  });

  // 3. Prepare reusable test data
  final tOrderHistory = [
    OrderEntity(
      id: 'order_123',
      customerId: 'cust_abc',
      items: const [],
      amount: 150.75,
      address: '123 Main St',
      phone: '555-1234',
      paymentMethod: 'Credit Card',
      status: OrderStatus.Delivered,
      discountApplied: true,
      pointsAwarded: 15,
      createdAt: DateTime(2023, 10, 26),
    ),
    OrderEntity(
      id: 'order_456',
      customerId: 'cust_abc',
      items: const [],
      amount: 88.20,
      address: '123 Main St',
      phone: '555-1234',
      paymentMethod: 'PayPal',
      status: OrderStatus.Delivered,
      discountApplied: false,
      pointsAwarded: 8,
      createdAt: DateTime(2023, 10, 20),
    ),
  ];
  final tFailure = ApiFailure(message: 'Could not fetch payment history');

  group('GetPaymentHistoryUseCase', () {
    test(
      'should get a list of orders (payment history) from the repository',
      () async {
        // Arrange
        // Stub the repository method to return the successful list of orders
        when(
          () => mockOrderRepository.getPaymentHistory(),
        ).thenAnswer((_) async => Right(tOrderHistory));

        // Act
        // Call the usecase (no parameters are needed)
        final result = await usecase();

        // Assert
        // Expect the result to be the successful list of orders
        expect(result, Right(tOrderHistory));
        // Verify that the repository's getPaymentHistory method was called exactly once
        verify(() => mockOrderRepository.getPaymentHistory()).called(1);
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
          () => mockOrderRepository.getPaymentHistory(),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase();

        // Assert
        // Expect the result to be the defined Failure
        expect(result, Left(tFailure));
        // Verify that the repository's method was still called
        verify(() => mockOrderRepository.getPaymentHistory()).called(1);
        // Ensure no other interactions
        verifyNoMoreInteractions(mockOrderRepository);
      },
    );
  });
}
