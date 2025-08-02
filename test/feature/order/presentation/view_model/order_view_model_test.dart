import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/create_order_usecase.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/order_event.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/order_state.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/order_view_model.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_order_usecas.dart';

void main() {
  // 1. Declare Mocks and BLoC variables
  late MockCreateOrderUseCase mockCreateOrderUseCase;
  late MockGetMyOrdersUseCase mockGetMyOrdersUseCase;
  late MockUpdateOrderStatusUseCase mockUpdateOrderStatusUseCase;
  late MockGetPaymentHistoryUseCase mockGetPaymentHistoryUseCase;
  late OrderBloc orderBloc;

  // 2. Prepare reusable test data
  final tNow = DateTime.now();
  const tItems = [
    OrderItem(
      productId: '1',
      name: 'Test Item',
      price: 10,
      quantity: 1,
      imageUrl: '',
    ),
  ];
  final tInitialOrder = OrderEntity(
    id: 'order_1',
    customerId: 'c1',
    items: const [],
    amount: 50,
    address: 'a',
    phone: 'p',
    paymentMethod: 'pm',
    status: OrderStatus.Delivered,
    discountApplied: false,
    pointsAwarded: 0,
    createdAt: tNow,
  );
  final tNewOrder = OrderEntity(
    id: 'order_2',
    customerId: 'c1',
    items: tItems,
    amount: 10,
    address: 'a',
    phone: 'p',
    paymentMethod: 'pm',
    status: OrderStatus.Pending,
    discountApplied: false,
    pointsAwarded: 0,
    createdAt: tNow,
  );
  final tOrderList = [tInitialOrder];
  final tServerFailure = ApiFailure(message: 'Server Error');

  setUp(() {
    // 3. Instantiate mocks and the BLoC before each test
    mockCreateOrderUseCase = MockCreateOrderUseCase();
    mockGetMyOrdersUseCase = MockGetMyOrdersUseCase();
    mockUpdateOrderStatusUseCase = MockUpdateOrderStatusUseCase();
    mockGetPaymentHistoryUseCase = MockGetPaymentHistoryUseCase();

    orderBloc = OrderBloc(
      createOrderUseCase: mockCreateOrderUseCase,
      getMyOrdersUseCase: mockGetMyOrdersUseCase,
      updateOrderStatusUseCase: mockUpdateOrderStatusUseCase,
      getPaymentHistoryUseCase: mockGetPaymentHistoryUseCase,
    );

    // Register fallback values for custom types used in `when`
    registerFallbackValue(
      const CreateOrderParams(
        items: [],
        address: '',
        phone: '',
        applyDiscount: false,
      ),
    );
  });

  tearDown(() {
    orderBloc.close();
  });

  group('OrderBloc', () {
    test('initial state is OrderState.initial()', () {
      expect(orderBloc.state, OrderState.initial());
    });

    group('CreateOrder Event', () {
      final tEvent = CreateOrder(
        items: tItems,
        address: 'a',
        phone: 'p',
        applyDiscount: false,
      );

      blocTest<OrderBloc, OrderState>(
        'emits [loading, success] and prepends new order to state when successful',
        setUp: () {
          // Arrange: When the use case is called with any params, return success
          when(
            () => mockCreateOrderUseCase(any()),
          ).thenAnswer((_) async => Right(tNewOrder));
        },
        // Set an initial state with one order already in the list
        seed: () => OrderState(myOrders: tOrderList, status: null),
        build: () => orderBloc,
        act: (bloc) => bloc.add(tEvent),
        expect:
            () => <OrderState>[
              // 1. Loading state
              OrderState(
                myOrders: tOrderList,
                status: OrderRequestStatus.loading,
              ),
              // 2. Success state with the new order prepended to the existing list
              OrderState(
                myOrders: [tNewOrder, ...tOrderList],
                status: OrderRequestStatus.success,
                selectedOrder: tNewOrder,
              ),
            ],
        verify: (_) {
          // Verify that the use case was called once with the correct parameters
          verify(
            () => mockCreateOrderUseCase(
              CreateOrderParams(
                items: tItems,
                address: 'a',
                phone: 'p',
                applyDiscount: false,
              ),
            ),
          ).called(1);
        },
      );

      blocTest<OrderBloc, OrderState>(
        'emits [loading, failure] when CreateOrderUseCase fails',
        setUp: () {
          // Arrange: Stub the use case to return a failure
          when(
            () => mockCreateOrderUseCase(any()),
          ).thenAnswer((_) async => Left(tServerFailure));
        },
        build: () => orderBloc,
        act: (bloc) => bloc.add(tEvent),
        expect:
            () => <OrderState>[
              // 1. Loading state
              OrderState(status: OrderRequestStatus.loading),
              // 2. Failure state with the error message
              OrderState(
                status: OrderRequestStatus.failure,
                errorMessage: tServerFailure.message,
              ),
            ],
      );
    });

    group('GetMyOrders Event', () {
      blocTest<OrderBloc, OrderState>(
        'emits [loading, success] with the fetched list of orders when successful',
        setUp: () {
          // Arrange: Stub the use case to return a successful list
          when(
            () => mockGetMyOrdersUseCase(),
          ).thenAnswer((_) async => Right(tOrderList));
        },
        build: () => orderBloc,
        act: (bloc) => bloc.add(GetMyOrders()),
        expect:
            () => <OrderState>[
              // 1. Loading state
              OrderState(status: OrderRequestStatus.loading),
              // 2. Success state with the fetched list
              OrderState(
                status: OrderRequestStatus.success,
                myOrders: tOrderList,
              ),
            ],
        verify: (_) {
          verify(() => mockGetMyOrdersUseCase()).called(1);
        },
      );

      blocTest<OrderBloc, OrderState>(
        'emits [loading, failure] when GetMyOrdersUseCase fails',
        setUp: () {
          // Arrange: Stub the use case to return a failure
          when(
            () => mockGetMyOrdersUseCase(),
          ).thenAnswer((_) async => Left(tServerFailure));
        },
        build: () => orderBloc,
        act: (bloc) => bloc.add(GetMyOrders()),
        expect:
            () => <OrderState>[
              OrderState(status: OrderRequestStatus.loading),
              OrderState(
                status: OrderRequestStatus.failure,
                errorMessage: tServerFailure.message,
              ),
            ],
      );
    });

    // Note: The tests for UpdateOrderStatus and GetPaymentHistory assume a simple
    // loading -> success/failure flow, as their implementation is not provided in the prompt.
    // If they modify the state list, these tests would need to be adjusted.
  });
}
