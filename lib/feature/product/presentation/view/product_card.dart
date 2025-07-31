import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view/cart_screen.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/cart_event.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/cart_state.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/cart_view_model.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/entity/product_entity.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;

  const ProductCard({super.key, required this.product});

  // --- LOGIC EXTRACTION ---
  // Logic for adding an item to the cart is moved here for cleanliness.
  void _onAddToCartPressed(BuildContext context) {
    // --- CRITICAL VALIDATION ---
    if (product.productId == null ||
        product.productId!.trim().isEmpty ||
        product.price == null ||
        product.name == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('This item is currently unavailable.'),
        ),
      );
      return; // Stop execution
    }

    // --- SAFE OBJECT CREATION & DISPATCH ---
    final orderItem = OrderItem(
      productId: product.productId!,
      quantity: 1,
      price: product.price!,
      name: product.name!,
      imageUrl: product.imageUrl ?? '',
    );

    context.read<CartBloc>().add(AddItemToCart(orderItem));

    // --- USER FEEDBACK ---
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart.'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      // Optimization: only rebuild if the cart item for *this* product has changed.
      buildWhen:
          (previous, current) =>
              previous.cartItems[product.productId] !=
              current.cartItems[product.productId],
      builder: (context, cartState) {
        final cartItem = cartState.cartItems[product.productId];
        final quantityInCart = cartItem?.quantity ?? 0;
        final isInCart = cartItem != null;

        // Using AspectRatio for a responsive card that maintains its shape.
        return AspectRatio(
          aspectRatio: 2 / 3,
          child: Card(
            // Card provides a modern look with elevation and rounded corners.
            elevation: 2,
            shadowColor: Colors.grey.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior:
                Clip.antiAlias, // Clips the child (InkWell) to the card's shape.
            child: InkWell(
              // Provides tap feedback. Can be used for navigation.
              onTap: () {
                // Example: Navigate to product detail screen
                // Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
                debugPrint("Tapped on ${product.name}");
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image Section
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          product.imageUrl ?? '',
                          fit: BoxFit.contain,
                          errorBuilder:
                              (context, error, stackTrace) => const Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                    ),
                  ),

                  // Product Details and Actions Section
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Name and Price
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name ?? 'No Name',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Nrs. ${product.price?.toStringAsFixed(0) ?? '0'}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),

                          // --- SMOOTH TRANSITION ---
                          // AnimatedSwitcher provides a smooth fade between the button and quantity changer.
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child:
                                isInCart
                                    ? _QuantityChanger(
                                      // Use a key to help AnimatedSwitcher identify the widget.
                                      key: ValueKey(product.productId),
                                      quantity: quantityInCart,
                                      onDecrement: () {
                                        context.read<CartBloc>().add(
                                          DecrementCartItem(product.productId!),
                                        );
                                      },
                                      onIncrement: () {
                                        context.read<CartBloc>().add(
                                          IncrementCartItem(product.productId!),
                                        );
                                      },
                                    )
                                    : _AddToCartButton(
                                      key: ValueKey(product.productId),
                                      onPressed:
                                          () => _onAddToCartPressed(context),
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// --- Helper Widgets (These are correct, no changes needed) ---

class _AddToCartButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _AddToCartButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 36,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 8),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Add to Cart',
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }
}

class _QuantityChanger extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantityChanger({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.remove, size: 18, color: Colors.green),
            onPressed: onDecrement,
          ),
          Text(
            '$quantity',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.add, size: 18, color: Colors.green),
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}
