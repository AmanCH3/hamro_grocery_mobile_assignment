import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/entity/product_entity.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/usecase/get_all_product_usecase.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/usecase/get_product_by_category.dart';
import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_event.dart';
import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_state.dart';
import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_view_model.dart';
import 'package:mocktail/mocktail.dart';

// 1. Create Mock Classes for the Usecase dependencies
class MockGetAllProductUsecase extends Mock implements GetAllProductUsecase {}

class MockGetProductsByCategoryUsecase extends Mock
    implements GetProductsByCategoryUsecase {}

void main() {
  // 2. Declare variables
  late MockGetAllProductUsecase mockGetAllProductUsecase;
  late MockGetProductsByCategoryUsecase mockGetProductsByCategoryUsecase;
  late ProductViewModel productViewModel;

  // 3. Prepare test data
  final tProductList = [
    const ProductEntity(productId: '1', name: 'Rice', price: 1000),
    const ProductEntity(productId: '2', name: 'Oil', price: 2000),
  ];
  const tCategoryName = 'fruits';
  final tCategoryProductList = [
    const ProductEntity(productId: '3', name: 'Apple', price: 150),
    const ProductEntity(productId: '4', name: 'Banana', price: 100),
  ];
  final tFailure = ApiFailure(message: 'Server Error');

  setUp(() {
    // 4. Instantiate mocks before each test
    mockGetAllProductUsecase = MockGetAllProductUsecase();
    mockGetProductsByCategoryUsecase = MockGetProductsByCategoryUsecase();

    // IMPORTANT: Stub the initial call from the constructor to prevent errors
    // in tests that don't focus on the constructor behavior.
    when(
      () => mockGetAllProductUsecase(),
    ).thenAnswer((_) async => Right(tProductList));

    // 5. Instantiate the ViewModel with the mocks
    productViewModel = ProductViewModel(
      getAllProductUsecase: mockGetAllProductUsecase,
      getProductsByCategoryUsecase: mockGetProductsByCategoryUsecase,
    );
  });

  tearDown(() {
    productViewModel.close();
  });

  group('ProductViewModel', () {
    test('initial state is ProductState.initial()', () {
      // Because the constructor adds an event, we create a fresh instance
      // without stubs to test its true initial state before the event is processed.
      final freshViewModel = ProductViewModel(
        getAllProductUsecase: mockGetAllProductUsecase,
        getProductsByCategoryUsecase: mockGetProductsByCategoryUsecase,
      );
      expect(freshViewModel.state, ProductState.initial());
      freshViewModel.close();
    });

    group('LoadProductsEvent (No Category)', () {
      blocTest<ProductViewModel, ProductState>(
        'emits [loading, success] when fetching all products is successful',
        setUp: () {
          when(
            () => mockGetAllProductUsecase(),
          ).thenAnswer((_) async => Right(tProductList));
        },
        // Build a fresh instance for this specific test
        build:
            () => ProductViewModel(
              getAllProductUsecase: mockGetAllProductUsecase,
              getProductsByCategoryUsecase: mockGetProductsByCategoryUsecase,
            ),
        expect:
            () => [
              ProductState(isLoading: true),
              ProductState(isLoading: false, products: tProductList),
            ],
        verify: (_) {
          verify(() => mockGetAllProductUsecase()).called(1);
          verifyNever(() => mockGetProductsByCategoryUsecase(any()));
        },
      );

      blocTest<ProductViewModel, ProductState>(
        'emits [loading, failure] when fetching all products fails',
        setUp: () {
          when(
            () => mockGetAllProductUsecase(),
          ).thenAnswer((_) async => Left(tFailure));
        },
        build:
            () => ProductViewModel(
              getAllProductUsecase: mockGetAllProductUsecase,
              getProductsByCategoryUsecase: mockGetProductsByCategoryUsecase,
            ),
        expect:
            () => [
              ProductState(isLoading: true),
              ProductState(isLoading: false, errorMessage: tFailure.message),
            ],
      );
    });

    group('LoadProductsEvent (With Category)', () {
      blocTest<ProductViewModel, ProductState>(
        'emits [loading, success] when fetching by category is successful',
        setUp: () {
          when(
            () => mockGetProductsByCategoryUsecase(tCategoryName),
          ).thenAnswer((_) async => Right(tCategoryProductList));
        },
        build: () => productViewModel,
        act:
            (bloc) =>
                bloc.add(const LoadProductsEvent(categoryName: tCategoryName)),
        expect:
            () => [
              // The state already has the initial list from the constructor
              productViewModel.state.copyWith(
                isLoading: true,
                errorMessage: null,
              ),
              productViewModel.state.copyWith(
                isLoading: false,
                products: tCategoryProductList,
              ),
            ],
        verify: (_) {
          verify(
            () => mockGetProductsByCategoryUsecase(tCategoryName),
          ).called(1);
          // Constructor calls this once, but it's not called during the `act` phase
          verify(() => mockGetAllProductUsecase()).called(1);
        },
      );

      blocTest<ProductViewModel, ProductState>(
        'emits [loading, failure] when fetching by category fails',
        setUp: () {
          when(
            () => mockGetProductsByCategoryUsecase(tCategoryName),
          ).thenAnswer((_) async => Left(tFailure));
        },
        build: () => productViewModel,
        act:
            (bloc) =>
                bloc.add(const LoadProductsEvent(categoryName: tCategoryName)),
        expect:
            () => [
              productViewModel.state.copyWith(
                isLoading: true,
                errorMessage: null,
              ),
              productViewModel.state.copyWith(
                isLoading: false,
                errorMessage: tFailure.message,
              ),
            ],
      );
    });
  });
}
