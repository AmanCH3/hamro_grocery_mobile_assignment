import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/feature/category/domain/entity/category_entity.dart';

class CategoryState extends Equatable {
  final List<CategoryEntity> categories;
  final bool isLoading;
  final String? errorMessage;

  const CategoryState({
    required this.categories,
    this.isLoading = false,
    this.errorMessage,
  });

  const CategoryState.initial()
    : categories = const [],
      isLoading = false,
      errorMessage = null;

  CategoryState copyWith({
    List<CategoryEntity>? categories,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [categories, isLoading, errorMessage];
}
