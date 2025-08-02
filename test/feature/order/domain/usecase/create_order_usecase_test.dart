import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/create_order_usecase.dart';
import 'package:mocktail/mocktail.dart';

// Assuming your mocks are in this file
import 'mock_token_repository.dart';

void main() {
  // 1. Declare variables
  late MockOrderRepository mockOrderRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;
  late CreateOrderUseCase usecase;

  setUp(() {
    // 2. Instantiate mocks and the usecase before each test
    mockOrderRepository = MockOrderRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    usecase = CreateOrderUseCase(
      repository: mockOrderRepository,
      tokenSharedPref: mockTokenSharedPrefs,
    );
  });

  // 3. Prepare reusable test data
  const tToken = '_test_auth_token_';
  // The type for OrderItemEntity in some files and OrderItem in others
  // is a bit inconsistent. I'm using OrderItem as per your CreateOrderParams.
  const tItems = [
    OrderItem(
      productId: '1',
      name: 'Test Item',
      price: 10,
      quantity: 1,
      imageUrl: '',
    ),
  ];
  const tParams = CreateOrderParams(
    items: tItems,
    address: '123 Test Street',
    phone: '9876543210',
    applyDiscount: false,
  );

  // --- CORRECTED SECTION ---
  // Create a DateTime object to use in the entity
  final tCreationTime = DateTime.now();

  // Create the test OrderEntity using the new, correct constructor
  final tOrderEntity = OrderEntity(
    id: 'order_123',
    customerId: 'cust_abc',
    items: tItems,
    amount: 10.0,
    address: tParams.address,
    phone: tParams.phone,
    paymentMethod: 'Cash on Delivery',
    status: OrderStatus.Pending, // Use the enum, not a string
    discountApplied: false,
    pointsAwarded: 0,
    createdAt: tCreationTime,
  );
  // --- END OF CORRECTION ---

  final tTokenFailure = ApiFailure(message: 'Could not retrieve token');
  final tServerFailure = ApiFailure(message: 'Failed to create order');

  group('CreateOrderUseCase', () {
    test(
      'should get token and create order from the repository successfully',
      () async {
        // Arrange
        when(
          () => mockTokenSharedPrefs.getToken(),
        ).thenAnswer((_) async => const Right(tToken));

        when(
          () => mockOrderRepository.createOrder(
            items: tParams.items,
            address: tParams.address,
            phone: tParams.phone,
            applyDiscount: tParams.applyDiscount,
            token: tToken,
          ),
        ).thenAnswer((_) async => Right(tOrderEntity));

        // Act
        final result = await usecase(tParams);

        // Assert
        expect(result, Right(tOrderEntity));
        verify(() => mockTokenSharedPrefs.getToken()).called(1);
        verify(
          () => mockOrderRepository.createOrder(
            items: tParams.items,
            address: tParams.address,
            phone: tParams.phone,
            applyDiscount: tParams.applyDiscount,
            token: tToken,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockOrderRepository);
        verifyNoMoreInteractions(mockTokenSharedPrefs);
      },
    );

    test('should return a Failure when token retrieval fails', () async {
      // Arrange
      when(
        () => mockTokenSharedPrefs.getToken(),
      ).thenAnswer((_) async => Left(tTokenFailure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, Left(tTokenFailure));
      verify(() => mockTokenSharedPrefs.getToken()).called(1);
      verifyNever(
        () => mockOrderRepository.createOrder(
          items: any(named: 'items'),
          address: any(named: 'address'),
          phone: any(named: 'phone'),
          applyDiscount: any(named: 'applyDiscount'),
          token: any(named: 'token'),
        ),
      );
      verifyNoMoreInteractions(mockTokenSharedPrefs);
      verifyNoMoreInteractions(mockOrderRepository);
    });

    test(
      'should return a Failure when repository fails to create order',
      () async {
        // Arrange
        when(
          () => mockTokenSharedPrefs.getToken(),
        ).thenAnswer((_) async => const Right(tToken));

        when(
          () => mockOrderRepository.createOrder(
            items: tParams.items,
            address: tParams.address,
            phone: tParams.phone,
            applyDiscount: tParams.applyDiscount,
            token: tToken,
          ),
        ).thenAnswer((_) async => Left(tServerFailure));

        // Act
        final result = await usecase(tParams);

        // Assert
        expect(result, Left(tServerFailure));
        verify(() => mockTokenSharedPrefs.getToken()).called(1);
        verify(
          () => mockOrderRepository.createOrder(
            items: tParams.items,
            address: tParams.address,
            phone: tParams.phone,
            applyDiscount: tParams.applyDiscount,
            token: tToken,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockOrderRepository);
        verifyNoMoreInteractions(mockTokenSharedPrefs);
      },
    );
  });
}
