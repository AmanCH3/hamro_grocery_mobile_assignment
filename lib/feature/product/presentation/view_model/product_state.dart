// // lib/feature/product/presentation/view_model/product_state.dart

// import 'package:equatable/equatable.dart';
// import 'package:hamro_grocery_mobile/feature/product/domain/entity/product_entity.dart';

// // No need to import ApiFailure here anymore
// // import 'package:hamro_grocery_mobile/core/error/failure.dart';

// class ProductState extends Equatable {
//   final List<ProductEntity> products;
//   final bool isLoading;
//   final String? errorMessage; // Your BLoC uses a String, not the Failure object

//   const ProductState({
//     required this.products,
//     this.isLoading = false,
//     this.errorMessage,
//   });

//   // A factory constructor for the initial state.
//   factory ProductState.initial() {
//     return const ProductState(
//       products: [],
//       isLoading: false,
//       errorMessage: null,
//     );
//   }

//   // CORRECTED copyWith method.
//   // It only takes optional parameters corresponding to the class fields.
//   ProductState copyWith({
//     List<ProductEntity>? products,
//     bool? isLoading,
//     String? errorMessage,
//   }) {
//     return ProductState(
//       products: products ?? this.products,
//       isLoading: isLoading ?? this.isLoading,
//       // This allows setting a new error or clearing an old one (by passing null).
//       errorMessage: errorMessage ?? this.errorMessage,
//     );
//   }

//   @override
//   List<Object?> get props => [products, isLoading, errorMessage];
// }

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/entity/product_entity.dart';

@immutable
class ProductState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  // This is the master list that holds ALL products.
  final List<ProductEntity> allProducts;
  // This is the list that gets displayed in the UI after filtering.
  final List<ProductEntity> filteredProducts;

  const ProductState({
    this.isLoading = false,
    this.errorMessage,
    this.allProducts = const [],
    this.filteredProducts = const [],
  });

  factory ProductState.initial() => const ProductState();

  ProductState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<ProductEntity>? allProducts,
    List<ProductEntity>? filteredProducts,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    allProducts,
    filteredProducts,
  ];
}
