import 'package:flutter/material.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/entity/product_entity.dart';

@immutable
class FavoritesState {
  final Map<String, ProductEntity> favoriteProducts;

  const FavoritesState({this.favoriteProducts = const {}});

  FavoritesState copyWith({Map<String, ProductEntity>? favoriteProducts}) {
    return FavoritesState(
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
    );
  }
}
