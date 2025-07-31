import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/category/domain/entity/category_entity.dart';
import 'package:hamro_grocery_mobile/feature/category/domain/usecase/get_all_category_usecase.dart';
import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_event.dart';
import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_state.dart';
import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllCategoryUsecase extends Mock implements GetAllCategoryUsecase {}

class MockApiFailure extends Mock implements ApiFailure {}

void main() {
  late MockGetAllCategoryUsecase mockGetAllCategoryUsecase;
  late CategoryViewModel categoryViewModel;

  setUp(() {
    mockGetAllCategoryUsecase = MockGetAllCategoryUsecase();
    categoryViewModel = CategoryViewModel(
      getAllCategoryUsecase: mockGetAllCategoryUsecase,
    );
  });
  const tCategory1 = CategoryEntity(categoryId: '1', name: 'Fruits');
  const tCategory2 = CategoryEntity(categoryId: '2', name: 'Vegetables');
  const tCategories = [tCategory1, tCategory2];

  group('CategoryViewModel', () {
    // Test for SUCCESS case
    testWidgets(
      'emits [loading, loaded] when LoadCategoriesEvent is added and usecase succeeds.',
      (tester) async {
        // Arrange: mock the usecase to return a success
        when(
          () => mockGetAllCategoryUsecase(),
        ).thenAnswer((_) async => Right(tCategories));

        // Act: add the event
        categoryViewModel.add(LoadCategoriesEvent());

        // Assert: expect the states
        expectLater(
          categoryViewModel.stream,
          emitsInOrder([
            CategoryState.initial().copyWith(isLoading: true),
            CategoryState.initial().copyWith(
              isLoading: false,
              categories: tCategories,
            ),
          ]),
        );
      },
    );

    // Test for FAILURE case
    testWidgets(
      'emits [loading, error] when LoadCategoriesEvent is added and usecase fails.',
      (tester) async {
        final tApiFailure = ApiFailure(
          message: 'Failed to fetch categories',
          statusCode: 500,
        );
        when(
          () => mockGetAllCategoryUsecase(),
        ).thenAnswer((_) async => Left(tApiFailure));

        categoryViewModel.add(LoadCategoriesEvent());

        expectLater(
          categoryViewModel.stream,
          emitsInOrder([
            CategoryState.initial().copyWith(isLoading: true),
            CategoryState.initial().copyWith(
              isLoading: false,
              errorMessage: tApiFailure.message,
            ),
          ]),
        );
      },
    );
  });

  testWidgets('category view model ...', (tester) async {
    // TODO: Implement test
  });
}
