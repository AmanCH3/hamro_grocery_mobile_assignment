// import 'package:flutter/material.dart';

// @immutable
// sealed class CategoryEvent {}

// final class LoadCategoriesEvent extends CategoryEvent {}

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
}

class LoadCategoriesEvent extends CategoryEvent {
  @override
  List<Object?> get props => [];
}

// Event to handle when a user taps a category chip. It can be null for the "All" category.
class SelectCategoryEvent extends CategoryEvent {
  final String? categoryId;

  const SelectCategoryEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}
