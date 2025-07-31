// // lib/feature/product/presentation/view_model/product_view_model.dart

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hamro_grocery_mobile/feature/product/domain/usecase/get_all_product_usecase.dart';
// import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_event.dart';
// import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_state.dart';

// class ProductViewModel extends Bloc<ProductEvent, ProductState> {
//   final GetAllProductUsecase getAllProductUsecase;
//   ProductViewModel({required this.getAllProductUsecase})
//     // Use the new factory constructor for a cleaner initial state
//     : super(ProductState.initial()) {
//     on<LoadProductsEvent>(_onLoadProducts);
//     // REMOVED: add(LoadProductsEvent());
//     // The UI should be responsible for adding this event.
//   }

//   Future<void> _onLoadProducts(
//     LoadProductsEvent event,
//     Emitter<ProductState> emit,
//   ) async {
//     emit(state.copyWith(isLoading: true, errorMessage: null));
//     final result = await getAllProductUsecase();

//     result.fold(
//       (failure) {
//         emit(state.copyWith(isLoading: false, errorMessage: failure.message));
//       },
//       (products) {
//         emit(state.copyWith(isLoading: false, products: products));
//       },
//     );
//   }
// }

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_view_model.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/usecase/get_all_product_usecase.dart';
import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_event.dart';
import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_state.dart';

class ProductViewModel extends Bloc<ProductEvent, ProductState> {
  final GetAllProductUsecase getAllProductUsecase;
  final CategoryViewModel categoryViewModel;
  late final StreamSubscription _categorySubscription;

  ProductViewModel({
    required this.getAllProductUsecase,
    required this.categoryViewModel,
  }) : super(ProductState.initial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<CategoryChangedEvent>(_onCategoryChanged);

    _categorySubscription = categoryViewModel.stream.listen((categoryState) {
      add(CategoryChangedEvent(categoryState.selectedCategoryId));
    });
  }

  @override
  Future<void> close() {
    _categorySubscription.cancel();
    return super.close();
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await getAllProductUsecase();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (products) {
        emit(
          state.copyWith(
            isLoading: false,
            allProducts: products,
            filteredProducts: products,
          ),
        );
        add(CategoryChangedEvent(categoryViewModel.state.selectedCategoryId));
      },
    );
  }

  void _onCategoryChanged(
    CategoryChangedEvent event,
    Emitter<ProductState> emit,
  ) {
    final categoryId = event.categoryId;

    if (categoryId == null) {
      emit(state.copyWith(filteredProducts: state.allProducts));
    } else {
      final filtered =
          state.allProducts
              .where((product) => product.category?.categoryId == categoryId)
              .toList();
      emit(state.copyWith(filteredProducts: filtered));
    }
  }
}
