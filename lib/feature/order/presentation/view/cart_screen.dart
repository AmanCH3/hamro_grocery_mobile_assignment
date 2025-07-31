  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
  import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/cart_event.dart';
  import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/cart_state.dart';
  import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/cart_view_model.dart';
  import 'package:intl/intl.dart';

  // 1. ADD THIS IMPORT to be able to navigate to the CreateOrderScreen
  import 'package:hamro_grocery_mobile/feature/order/presentation/view/create_order_screen.dart';

  class CartScreen extends StatelessWidget {
    const CartScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Cart'),
          centerTitle: true,
          actions: [
            // A button to clear the cart, only visible when not empty.
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state.cartItems.isNotEmpty) {
                  return IconButton(
                    icon: const Icon(Icons.delete_sweep_outlined),
                    onPressed: () {
                      // Show a confirmation dialog before clearing the cart
                      showDialog(
                        context: context,
                        builder:
                            (dialogContext) => AlertDialog(
                              title: const Text('Clear Cart?'),
                              content: const Text(
                                'Are you sure you want to remove all items from your cart?',
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed:
                                      () => Navigator.of(dialogContext).pop(),
                                ),
                                TextButton(
                                  child: const Text('Clear'),
                                  onPressed: () {
                                    context.read<CartBloc>().add(ClearCart());
                                    Navigator.of(dialogContext).pop();
                                  },
                                ),
                              ],
                            ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            // --- Loading State ---
            if (state.status == CartStatus.initial ||
                (state.status == CartStatus.loading && state.cartItems.isEmpty)) {
              return const Center(child: CircularProgressIndicator());
            }

            // --- Failure State ---
            if (state.status == CartStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.errorMessage ?? 'Failed to load cart.'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<CartBloc>().add(LoadCart()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // --- Empty State ---
            if (state.cartItems.isEmpty) {
              return const Center(
                child: Text(
                  'Your cart is empty.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            // --- Success State with Items ---
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                          bottom: 150,
                        ), // Space for summary
                        itemCount: state.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = state.cartItems.values.elementAt(index);
                          return _CartItemCard(item: item);
                        },
                      ),
                    ),
                  ],
                ),
                // Show a loading overlay when modifying the cart
                if (state.status == CartStatus.loading)
                  Container(
                    color: Colors.black.withOpacity(0.1),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
        // 2. REPLACE the old bottomSheet with your new code.
        // --- Bottom Summary and Checkout Button ---
        bottomSheet: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state.cartItems.isEmpty) {
              return const SizedBox.shrink();
            }
            return _CartSummary(
              totalPrice: state.totalPrice,
              onCheckout: () {
                // MODIFIED: Navigate to the new CreateOrderScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => CreateOrderScreen(
                          // Pass the required data from the cart state
                          items: state.cartItems.values.toList(),
                          totalPrice: state.totalPrice,
                        ),
                  ),
                );
              },
            );
          },
        ),
      );
    }
  }

  /// A private widget to display a single cart item.
  class _CartItemCard extends StatelessWidget {
    final OrderItem item;
    const _CartItemCard({required this.item});

    @override
    Widget build(BuildContext context) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Product Image
              SizedBox(
                width: 80,
                height: 80,
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported),
                ),
              ),
              const SizedBox(width: 16),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${NumberFormat.currency(symbol: 'Nrs. ').format(item.price)}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    // Quantity Selector
                    Row(
                      children: [
                        _buildQuantityButton(
                          icon: Icons.remove,
                          onPressed:
                              () => context.read<CartBloc>().add(
                                DecrementCartItem(item.productId),
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            item.quantity.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buildQuantityButton(
                          icon: Icons.add,
                          onPressed:
                              () => context.read<CartBloc>().add(
                                IncrementCartItem(item.productId),
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Remove Button
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed:
                    () => context.read<CartBloc>().add(
                      RemoveItemFromCart(item.productId),
                    ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildQuantityButton({
      required IconData icon,
      required VoidCallback onPressed,
    }) {
      return InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, size: 18),
        ),
      );
    }
  }

  /// A private widget for the summary section at the bottom.
  class _CartSummary extends StatelessWidget {
    final double totalPrice;
    final VoidCallback onCheckout;

    const _CartSummary({required this.totalPrice, required this.onCheckout});

    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(
          16,
        ).copyWith(bottom: 24), // Extra padding for safe area
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  NumberFormat.currency(symbol: 'Nrs. ').format(totalPrice),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCheckout,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Proceed to Checkout'),
              ),
            ),
          ],
        ),
      );
    }
  }
