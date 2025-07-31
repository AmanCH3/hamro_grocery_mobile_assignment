// import 'package:equatable/equatable.dart';
// import 'package:hamro_grocery_mobile/feature/category/domain/entity/category_entity.dart';

// class CategoryState extends Equatable {
//   final List<CategoryEntity> categories;
//   final bool isLoading;
//   final String? errorMessage;

//   const CategoryState({
//     required this.categories,
//     this.isLoading = false,
//     this.errorMessage,
//   });

//   const CategoryState.initial()
//     : categories = const [],
//       isLoading = false,
//       errorMessage = null;

//   CategoryState copyWith({
//     List<CategoryEntity>? categories,
//     bool? isLoading,
//     String? errorMessage,
//   }) {
//     return CategoryState(
//       categories: categories ?? this.categories,
//       isLoading: isLoading ?? this.isLoading,
//       errorMessage: errorMessage ?? this.errorMessage,
//     );
//   }

//   @override
//   List<Object?> get props => [categories, isLoading, errorMessage];
// }

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hamro_grocery_mobile/feature/category/domain/entity/category_entity.dart';

@immutable
class CategoryState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<CategoryEntity> categories;
  // This property will track which category is currently selected.
  final String? selectedCategoryId;

  const CategoryState({
    this.isLoading = false,
    this.errorMessage,
    this.categories = const [],
    this.selectedCategoryId,
  });

  factory CategoryState.initial() => const CategoryState();

  CategoryState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<CategoryEntity>? categories,
    // A helper function allows us to explicitly set selectedCategoryId to null.
    String? Function()? selectedCategoryId,
  }) {
    return CategoryState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      categories: categories ?? this.categories,
      selectedCategoryId:
          selectedCategoryId != null
              ? selectedCategoryId()
              : this.selectedCategoryId,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    categories,
    selectedCategoryId,
  ];
}
