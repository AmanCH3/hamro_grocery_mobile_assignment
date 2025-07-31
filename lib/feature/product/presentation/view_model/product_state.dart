// lib/feature/product/presentation/view_model/product_state.dart

import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/entity/product_entity.dart';

// No need to import ApiFailure here anymore
// import 'package:hamro_grocery_mobile/core/error/failure.dart';

class ProductState extends Equatable {
  final List<ProductEntity> products;
  final bool isLoading;
  final String? errorMessage; // Your BLoC uses a String, not the Failure object

  const ProductState({
    required this.products,
    this.isLoading = false,
    this.errorMessage,
  });

  // A factory constructor for the initial state.
  factory ProductState.initial() {
    return const ProductState(
      products: [],
      isLoading: false,
      errorMessage: null,
    );
  }

  // CORRECTED copyWith method.
  // It only takes optional parameters corresponding to the class fields.
  ProductState copyWith({
    List<ProductEntity>? products,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      // This allows setting a new error or clearing an old one (by passing null).
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [products, isLoading, errorMessage];
}
