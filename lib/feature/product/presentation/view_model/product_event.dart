// import 'package:flutter/material.dart';

// @immutable
// sealed class ProductEvent {}

// final class LoadProductsEvent extends ProductEvent {}

import 'package:equatable/equatable.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();
}

class LoadProductsEvent extends ProductEvent {
  @override
  List<Object?> get props => [];
}

class CategoryChangedEvent extends ProductEvent {
  final String? categoryId;

  // The 'const' is removed because Equatable does not have a const constructor.
  const CategoryChangedEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}
