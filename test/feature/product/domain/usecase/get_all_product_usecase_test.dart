// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hamro_grocery_mobile/feature/product/domain/entity/product_entity.dart';
// import 'package:hamro_grocery_mobile/feature/product/domain/usecase/get_all_product_usecase.dart';
// import 'package:mocktail/mocktail.dart';
// import '../mock_repository.dart';
//
// void main() {
//   // 2. Declare variables with the CORRECT mock type.
//   late MockProductRepository mockProductRepository;
//   late GetAllProductUsecase getAllProductUsecase;
//
//   setUp(() {
//     // 3. Instantiate the correct mock object.
//     mockProductRepository = MockProductRepository();
//
//     getAllProductUsecase = GetAllProductUsecase(
//       productRepository: mockProductRepository,
//     );
//   });
//
//   test('should get a list of products from the repository', () async {
//     // Arrange
//     final tProductList = [
//       const ProductEntity(id: '1', name: 'Rice', price: 1000, imageUrl: ''),
//       const ProductEntity(id: '2', name: 'Oil', price: 2000, imageUrl: ''),
//     ];
//
//     when(
//       () => mockProductRepository.getAllProducts(),
//     ).thenAnswer((_) async => Right(tProductList));
//
//     // Act
//     final result = await getAllProductUsecase();
//
//     // Assert
//     expect(result, Right(tProductList));
//     verify(() => mockProductRepository.getAllProducts()).called(1);
//     verifyNoMoreInteractions(mockProductRepository);
//   });
// }
