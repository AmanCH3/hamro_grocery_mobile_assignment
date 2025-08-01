import 'package:flutter/material.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/entity/product_entity.dart';

@immutable
abstract class FavoriteEvent {}

class AddToFavorites extends FavoriteEvent {
  final ProductEntity product;
  AddToFavorites(this.product);
}

class RemoveFromFavorites extends FavoriteEvent {
  final String productId;
  RemoveFromFavorites(this.productId);
}
