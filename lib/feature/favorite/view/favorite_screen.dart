import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/feature/favorite/view_model/favorite_event.dart';
import 'package:hamro_grocery_mobile/feature/favorite/view_model/favorite_state.dart';
import 'package:hamro_grocery_mobile/feature/favorite/view_model/favorite_view_model.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/entity/product_entity.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state.favoriteProducts.isEmpty) {
            return _buildEmptyView(context);
          }

          final favoriteList = state.favoriteProducts.values.toList();

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: favoriteList.length,
            itemBuilder: (context, index) {
              final product = favoriteList[index];
              return _FavoriteListItem(product: product);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            const Text(
              'No Favorites Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tap the heart on any product to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteListItem extends StatelessWidget {
  final ProductEntity product;
  const _FavoriteListItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.imageUrl ?? '',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
            ),
          ),
          title: Text(
            product.name ?? 'No Name',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            'Nrs. ${product.price?.toStringAsFixed(0) ?? '0'}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () {
              context.read<FavoritesBloc>().add(
                RemoveFromFavorites(product.productId!),
              );
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('${product.name} removed from favorites.'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
            },
          ),
        ),
      ),
    );
  }
}
