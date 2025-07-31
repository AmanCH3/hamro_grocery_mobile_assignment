// import 'package:bloc_test/bloc_test.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hamro_grocery_mobile/core/error/failure.dart';
// import 'package:hamro_grocery_mobile/feature/product/domain/entity/product_entity.dart';
// import 'package:hamro_grocery_mobile/feature/product/domain/usecase/get_all_product_usecase.dart';
// import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_event.dart';
// import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_state.dart';
// import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_view_model.dart';
// import 'package:mocktail/mocktail.dart';
//
// class MockGetAllProductUsecase extends Mock implements GetAllProductUsecase {}
//
// class MockApiFailure extends Mock implements ApiFailure {}
//
// void main() {
//   late GetAllProductUsecase mockGetAllProductUsecase;
//   late ProductViewModel productViewModel;
//
//   setUp(() {
//     mockGetAllProductUsecase = MockGetAllProductUsecase();
//     productViewModel = ProductViewModel(
//       getAllProductUsecase: mockGetAllProductUsecase,
//     );
//   });
//
//   final tProduct1 = ProductEntity(
//     id: '1',
//     name: 'Rice',
//     price: 1000,
//     imageUrl: '',
//   );
//
//   final tProduct2 = ProductEntity(
//     id: '2',
//     name: 'Oil',
//     price: 2000,
//     imageUrl: '',
//   );
//   final tProductList = [tProduct1, tProduct2];
//   final tApiFailure = ApiFailure(
//     message: 'Server error occurred.',
//     statusCode: 500,
//   );
//
//   group('ProductViewModel', () {
//     // Test for SUCCESS case
//     blocTest<ProductViewModel, ProductState>(
//       'emits [loading, loaded] when LoadProductsEvent is added and usecase succeeds.',
//       build: () {
//         // Arrange: mock the usecase to return a success
//         when(
//           () => mockGetAllProductUsecase(),
//         ).thenAnswer((_) async => Right(tProductList));
//         return productViewModel;
//       },
//       act: (viewModel) => viewModel.add(LoadProductsEvent()),
//       expect:
//           () => <ProductState>[
//             // Expect the loading state first
//             ProductState.initial().copyWith(isLoading: true, products: []),
//             // Then expect the loaded state with data
//             ProductState.initial().copyWith(
//               isLoading: false,
//               products: tProductList,
//             ),
//           ],
//       // Verify that the usecase was called exactly once
//       verify: (_) {
//         verify(() => mockGetAllProductUsecase()).called(1);
//       },
//     );
//
//     // Test for FAILURE case
//     blocTest<ProductViewModel, ProductState>(
//       'emits [loading, error] when LoadProductsEvent is added and usecase fails.',
//       build: () {
//         // Arrange: mock the usecase to return a failure
//         when(
//           () => mockGetAllProductUsecase(),
//         ).thenAnswer((_) async => Left(tApiFailure));
//         return productViewModel;
//       },
//       act: (viewModel) => viewModel.add(LoadProductsEvent()),
//       expect:
//           () => <ProductState>[
//             // Expect the loading state first
//             ProductState.initial().copyWith(isLoading: true),
//             // Then expect the error state
//             ProductState.initial().copyWith(
//               isLoading: false,
//               errorMessage: tApiFailure.message, // Use the failure message
//             ),
//           ],
//       // Verify that the usecase was called exactly once
//       verify: (_) {
//         verify(() => mockGetAllProductUsecase()).called(1);
//       },
//     );
//   });
// }
