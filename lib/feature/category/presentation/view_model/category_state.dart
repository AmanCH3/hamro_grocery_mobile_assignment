import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/feature/category/domain/entity/category_entity.dart';

class CategoryState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<CategoryEntity> categories;
  final String? selectedCategoryId; // This can be null for "All"

  const CategoryState({
    required this.isLoading,
    this.errorMessage,
    required this.categories,
    this.selectedCategoryId,
  });

  // Factory for the initial state
  factory CategoryState.initial() {
    return const CategoryState(
      isLoading: false,
      categories: [],
      errorMessage: null,
      selectedCategoryId: null, // Start with "All" selected
    );
  }

  // --- FIX: The copyWith method should accept a nullable String ---
  // The use of `String? Function()` was the source of the bug.
  CategoryState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<CategoryEntity>? categories,
    String? selectedCategoryId,
  }) {
    return CategoryState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId, // Directly assign the new value
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    categories,
    selectedCategoryId, // IMPORTANT: Must be in props for Bloc to detect changes
  ];
}
