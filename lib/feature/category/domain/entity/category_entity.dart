import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String categoryId;
  final String name;

  const CategoryEntity({required this.categoryId, required this.name});

  @override
  List<Object?> get props => [categoryId, name];
}
