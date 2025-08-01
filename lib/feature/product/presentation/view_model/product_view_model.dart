import 'package:bloc/bloc.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/usecase/get_all_product_usecase.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/usecase/get_product_by_category.dart';
import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_event.dart';
import 'package:hamro_grocery_mobile/feature/product/presentation/view_model/product_state.dart';

class ProductViewModel extends Bloc<ProductEvent, ProductState> {
  final GetAllProductUsecase getAllProductUsecase;
  // --- NEW: Add the new usecase as a dependency ---
  final GetProductsByCategoryUsecase getProductsByCategoryUsecase;

  ProductViewModel({
    required this.getAllProductUsecase,
    required this.getProductsByCategoryUsecase,
  }) : super(ProductState.initial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    add(const LoadProductsEvent());
  }
  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    // Choose which usecase to call based on the event property
    final result =
        event.categoryName == null
            ? await getAllProductUsecase()
            : await getProductsByCategoryUsecase(event.categoryName!);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (products) {
        emit(
          state.copyWith(
            isLoading: false,
            products: products, // Update the single products list
          ),
        );
      },
    );
  }

  // --- REMOVED: _onCategoryChanged is no longer needed ---
}
