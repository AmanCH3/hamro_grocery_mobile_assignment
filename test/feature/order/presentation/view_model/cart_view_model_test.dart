import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/update_cart_item_usecase.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/cart_event.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/cart_state.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/cart_view_model.dart';
import 'package:mocktail/mocktail.dart';

// Import your mock use case classes
import 'mock_cart_view_model_.dart'; // Adjust path if needed

void main() {
  // 1. Declare Mocks and BLoC variables
  late MockGetCartItemsUseCase mockGetCartItemsUseCase;
  late MockAddItemToCartUseCase mockAddItemToCartUseCase;
  late MockUpdateCartItemQuantityUseCase mockUpdateCartItemQuantityUseCase;
  late MockRemoveItemFromCartUseCase mockRemoveItemFromCartUseCase;
  late MockClearCartUseCase mockClearCartUseCase;
  late CartBloc cartBloc;

  // 2. Prepare reusable test data
  const tItem1 = OrderItem(
    productId: '1',
    name: 'Apple',
    price: 1.0,
    quantity: 1,
    imageUrl: '',
  );
  const tItem2 = OrderItem(
    productId: '2',
    name: 'Banana',
    price: 0.5,
    quantity: 2,
    imageUrl: '',
  );
  final tInitialCartList = [tItem1, tItem2];
  final tInitialCartMap = {tItem1.productId: tItem1, tItem2.productId: tItem2};
  final tFailure = ApiFailure(message: 'Cache Error');

  setUp(() {
    // 3. Instantiate mocks and register fallbacks
    mockGetCartItemsUseCase = MockGetCartItemsUseCase();
    mockAddItemToCartUseCase = MockAddItemToCartUseCase();
    mockUpdateCartItemQuantityUseCase = MockUpdateCartItemQuantityUseCase();
    mockRemoveItemFromCartUseCase = MockRemoveItemFromCartUseCase();
    mockClearCartUseCase = MockClearCartUseCase();

    registerFallbackValue(const UpdateCartItemParams(id: '', newQuantity: 0));
    registerFallbackValue(tItem1); // Fallback for OrderItem

    // Default stub for the constructor's initial load. This is crucial.
    when(
      () => mockGetCartItemsUseCase(),
    ).thenAnswer((_) async => Right(tInitialCartList));

    // 4. Instantiate the BLoC
    cartBloc = CartBloc(
      getCartItemsUseCase: mockGetCartItemsUseCase,
      addItemToCartUseCase: mockAddItemToCartUseCase,
      updateCartItemQuantityUseCase: mockUpdateCartItemQuantityUseCase,
      removeItemFromCartUseCase: mockRemoveItemFromCartUseCase,
      clearCartUseCase: mockClearCartUseCase,
    );
  });

  tearDown(() {
    cartBloc.close();
  });

  group('CartBloc', () {
    test('initial state is CartState.initial()', () {
      // Test a fresh BLoC to check its state before the constructor event runs
      final freshBloc = CartBloc(
        getCartItemsUseCase: mockGetCartItemsUseCase,
        addItemToCartUseCase: mockAddItemToCartUseCase,
        updateCartItemQuantityUseCase: mockUpdateCartItemQuantityUseCase,
        removeItemFromCartUseCase: mockRemoveItemFromCartUseCase,
        clearCartUseCase: mockClearCartUseCase,
      );
      expect(freshBloc.state, CartState.initial());
      freshBloc.close();
    });

    group('Constructor and LoadCart Event', () {
      blocTest<CartBloc, CartState>(
        'emits [loading, success] with fetched items when created',
        build: () => cartBloc, // Use the instance from setUp
        // No 'act' is needed because the constructor adds the LoadCart event.
        expect:
            () => [
              // FIX #1: The loading state must contain the cartItems from the PREVIOUS (initial) state.
              CartState(status: CartStatus.loading, cartItems: const {}),
              CartState(status: CartStatus.success, cartItems: tInitialCartMap),
            ],
        verify: (_) {
          verify(() => mockGetCartItemsUseCase()).called(1);
        },
      );
    });

    group('AddItemToCart Event', () {
      const tNewItem = OrderItem(
        productId: '3',
        name: 'Orange',
        price: 1.2,
        quantity: 1,
        imageUrl: '',
      );

      blocTest<CartBloc, CartState>(
        'when adding a NEW item, optimistically updates, calls add use case, and reloads',
        setUp: () {
          // FIX #2: Stub both the initial action AND the subsequent reload action.
          when(
            () => mockAddItemToCartUseCase(tNewItem),
          ).thenAnswer((_) async => const Right(unit));
          // When LoadCart is called again, it should return the fully updated list.
          when(
            () => mockGetCartItemsUseCase(),
          ).thenAnswer((_) async => Right([...tInitialCartList, tNewItem]));
        },
        build: () => cartBloc,
        // Start from a known successful state
        seed:
            () => CartState(
              status: CartStatus.success,
              cartItems: tInitialCartMap,
            ),
        act: (bloc) => bloc.add(const AddItemToCart(tNewItem)),
        expect: () {
          final optimisticallyUpdatedMap = Map<String, OrderItem>.from(
            tInitialCartMap,
          )..[tNewItem.productId] = tNewItem;
          final finalCartMap = {
            for (var item in [...tInitialCartList, tNewItem])
              item.productId: item,
          };

          return [
            // State 1: Optimistic update. Status is loading, map includes the new item.
            CartState(
              status: CartStatus.loading,
              cartItems: optimisticallyUpdatedMap,
            ),
            // State 2: The `LoadCart` event is added, which first emits a loading state.
            // The cartItems are carried over from the previous state.
            CartState(
              status: CartStatus.loading,
              cartItems: optimisticallyUpdatedMap,
            ),
            // State 3: The `LoadCart` event finishes successfully with the re-fetched data.
            CartState(status: CartStatus.success, cartItems: finalCartMap),
          ];
        },
        verify: (_) {
          verify(() => mockAddItemToCartUseCase(tNewItem)).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'when adding an EXISTING item, optimistically updates, calls update use case, and reloads',
        setUp: () {
          when(
            () => mockUpdateCartItemQuantityUseCase(any()),
          ).thenAnswer((_) async => const Right(unit));
          // Stub the reload to return the list with the updated quantity.
          when(() => mockGetCartItemsUseCase()).thenAnswer(
            (_) async => Right([tItem1.copyWith(quantity: 2), tItem2]),
          );
        },
        build: () => cartBloc,
        seed:
            () => CartState(
              status: CartStatus.success,
              cartItems: tInitialCartMap,
            ),
        act:
            (bloc) =>
                bloc.add(const AddItemToCart(tItem1)), // Add the existing item
        expect: () {
          final optimisticallyUpdatedMap = Map<String, OrderItem>.from(
            tInitialCartMap,
          )..[tItem1.productId] = tItem1.copyWith(quantity: 2);
          final finalCartMap = {
            tItem1.productId: tItem1.copyWith(quantity: 2),
            tItem2.productId: tItem2,
          };

          return [
            CartState(
              status: CartStatus.loading,
              cartItems: optimisticallyUpdatedMap,
            ),
            CartState(
              status: CartStatus.loading,
              cartItems: optimisticallyUpdatedMap,
            ),
            CartState(status: CartStatus.success, cartItems: finalCartMap),
          ];
        },
        verify: (_) {
          verify(
            () => mockUpdateCartItemQuantityUseCase(
              const UpdateCartItemParams(id: '1', newQuantity: 2),
            ),
          ).called(1);
        },
      );
    });

    group('DecrementCartItem Event', () {
      blocTest<CartBloc, CartState>(
        'when quantity > 1, calls update use case and reloads',
        setUp: () {
          when(
            () => mockUpdateCartItemQuantityUseCase(any()),
          ).thenAnswer((_) async => const Right(unit));
          when(() => mockGetCartItemsUseCase()).thenAnswer(
            (_) async => Right([tItem1, tItem2.copyWith(quantity: 1)]),
          );
        },
        build: () => cartBloc,
        seed:
            () => CartState(
              status: CartStatus.success,
              cartItems: tInitialCartMap,
            ),
        act:
            (bloc) =>
                bloc.add(const DecrementCartItem('2')), // tItem2 has quantity 2
        expect:
            () => [
              CartState(status: CartStatus.loading, cartItems: tInitialCartMap),
              CartState(status: CartStatus.loading, cartItems: tInitialCartMap),
              CartState(
                status: CartStatus.success,
                cartItems: {
                  tItem1.productId: tItem1,
                  tItem2.productId: tItem2.copyWith(quantity: 1),
                },
              ),
            ],
        verify: (_) {
          verify(
            () => mockUpdateCartItemQuantityUseCase(
              const UpdateCartItemParams(id: '2', newQuantity: 1),
            ),
          ).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'when quantity is 1, calls remove use case and reloads',
        setUp: () {
          when(
            () => mockRemoveItemFromCartUseCase(any()),
          ).thenAnswer((_) async => const Right(unit));
          when(
            () => mockGetCartItemsUseCase(),
          ).thenAnswer((_) async => Right([tItem2])); // Only tItem2 remains
        },
        build: () => cartBloc,
        seed:
            () => CartState(
              status: CartStatus.success,
              cartItems: tInitialCartMap,
            ),
        act:
            (bloc) =>
                bloc.add(const DecrementCartItem('1')), // tItem1 has quantity 1
        expect:
            () => [
              CartState(status: CartStatus.loading, cartItems: tInitialCartMap),
              CartState(status: CartStatus.loading, cartItems: tInitialCartMap),
              CartState(
                status: CartStatus.success,
                cartItems: {tItem2.productId: tItem2},
              ),
            ],
        verify: (_) {
          verify(() => mockRemoveItemFromCartUseCase('1')).called(1);
        },
      );
    });

    group('ClearCart Event', () {
      blocTest<CartBloc, CartState>(
        'calls clear use case and reloads an empty cart',
        setUp: () {
          when(
            () => mockClearCartUseCase(),
          ).thenAnswer((_) async => const Right(unit));
          when(() => mockGetCartItemsUseCase()).thenAnswer(
            (_) async => const Right([]),
          ); // Reload returns empty list
        },
        build: () => cartBloc,
        seed:
            () => CartState(
              status: CartStatus.success,
              cartItems: tInitialCartMap,
            ),
        act: (bloc) => bloc.add(ClearCart()),
        expect:
            () => [
              CartState(status: CartStatus.loading, cartItems: tInitialCartMap),
              CartState(status: CartStatus.loading, cartItems: tInitialCartMap),
              CartState(status: CartStatus.success, cartItems: const {}),
            ],
        verify: (_) {
          verify(() => mockClearCartUseCase()).called(1);
        },
      );
    });
  });
}
