import 'package:bloc/bloc.dart';

import 'package:hamro_grocery_mobile/feature/category/domain/usecase/get_all_category_usecase.dart';
import 'package:hamro_grocery_mobile/feature/category/presentation/view/category_card.dart';
import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_event.dart';
import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_state.dart';

class CategoryViewModel extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategoryUsecase getAllCategoryUsecase;

  CategoryViewModel({required this.getAllCategoryUsecase})
    : super(CategoryState.initial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<SelectCategoryEvent>(_onSelectCategory);

    add(LoadCategoriesEvent());
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await getAllCategoryUsecase();
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (categories) {
        emit(state.copyWith(categories: categories, isLoading: false));
      },
    );
  }

  // Handles the selection logic.
  void _onSelectCategory(
    SelectCategoryEvent event,
    Emitter<CategoryState> emit,
  ) {
    emit(state.copyWith(selectedCategoryId: () => event.categoryId));
  }
}
