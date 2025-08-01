import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/entity/product_entity.dart';

@immutable
class ProductState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  // --- SIMPLIFIED: We only need one list of products to display ---
  final List<ProductEntity> products;

  const ProductState({
    this.isLoading = false,
    this.errorMessage,
    this.products = const [],
  });

  factory ProductState.initial() => const ProductState();

  ProductState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<ProductEntity>? products,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, products];
}
