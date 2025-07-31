import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/feature/category/domain/entity/category_entity.dart';
import 'package:hamro_grocery_mobile/feature/category/domain/usecase/get_all_category_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../repository_mock.dart';
import 'token_mock.dart';

void main() {
  late MockRepository mockRepository;
  late GetAllCategoryUsecase getAllCategoryUsecase;

  setUp(() {
    mockRepository = MockRepository();
    getAllCategoryUsecase = GetAllCategoryUsecase(
      categoryRepository: mockRepository,
    );
  });

  const tCategory1 = CategoryEntity(categoryId: '1', name: 'Fruits');
  const tCategory2 = CategoryEntity(categoryId: '2', name: 'Vegetables');

  const tCategories = [tCategory1, tCategory2];

  testWidgets('get all category usecase ...', (tester) async {
    when(
      () => mockRepository.getAllCategories(),
    ).thenAnswer((_) async => Right(tCategories));
    final result = await getAllCategoryUsecase();
    expect(result, Right(tCategories));

    verify(() => mockRepository.getAllCategories()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
