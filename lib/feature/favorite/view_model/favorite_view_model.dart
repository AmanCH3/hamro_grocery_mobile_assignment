import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/feature/favorite/view_model/favorite_event.dart';
import 'package:hamro_grocery_mobile/feature/favorite/view_model/favorite_state.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/entity/product_entity.dart';

class FavoritesBloc extends Bloc<FavoriteEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesState()) {
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
  }

  void _onAddToFavorites(AddToFavorites event, Emitter<FavoritesState> emit) {
    // Create a new map from the current state to ensure immutability
    final newFavorites = Map<String, ProductEntity>.from(
      state.favoriteProducts,
    );
    if (event.product.productId != null) {
      newFavorites[event.product.productId!] = event.product;
      emit(state.copyWith(favoriteProducts: newFavorites));
    }
  }

  void _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<FavoritesState> emit,
  ) {
    final newFavorites = Map<String, ProductEntity>.from(
      state.favoriteProducts,
    );
    newFavorites.remove(event.productId);
    emit(state.copyWith(favoriteProducts: newFavorites));
  }
}
