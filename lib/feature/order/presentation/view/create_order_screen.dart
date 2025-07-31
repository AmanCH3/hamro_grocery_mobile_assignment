import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/cart_event.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/cart_view_model.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/order_event.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/order_state.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/order_view_model.dart';
import 'package:intl/intl.dart';

class CreateOrderScreen extends StatefulWidget {
  final List<OrderItem> items;
  final double totalPrice;

  const CreateOrderScreen({
    super.key,
    required this.items,
    required this.totalPrice,
  });

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _applyDiscount = false;

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _placeOrder() {
    // Validate the form before proceeding
    if (_formKey.currentState!.validate()) {
      context.read<OrderBloc>().add(
        CreateOrder(
          items: widget.items,
          address: _addressController.text.trim(),
          phone: _phoneController.text.trim(),
          applyDiscount: _applyDiscount,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Order'), centerTitle: true),
      body: BlocListener<OrderBloc, OrderState>(
        // Use BlocListener for side-effects like navigation and SnackBars
        listener: (context, state) {
          if (state.status == OrderRequestStatus.success) {
            // Order was placed successfully
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Order placed successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            // Clear the cart
            context.read<CartBloc>().add(ClearCart());
            // Navigate back to the root (home) screen
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (state.status == OrderRequestStatus.failure) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Failed to place order.'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Delivery Information'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Full Address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your delivery address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (value.length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _buildSectionHeader('Member Perks'),
                SwitchListTile(
                  title: const Text('Apply 10% Member Discount'),
                  subtitle: const Text('Uses available loyalty points.'),
                  value: _applyDiscount,
                  onChanged: (value) {
                    setState(() {
                      _applyDiscount = value;
                    });
                  },
                  secondary: const Icon(Icons.star_border),
                ),
                const SizedBox(height: 24),
                _buildSectionHeader('Order Summary'),
                _buildOrderSummaryCard(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildPlaceOrderButton(),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Amount:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              NumberFormat.currency(symbol: 'Nrs. ').format(widget.totalPrice),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceOrderButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<OrderBloc, OrderState>(
        // Use BlocBuilder to change the button's UI (e.g., show a loader)
        builder: (context, state) {
          final isLoading = state.status == OrderRequestStatus.loading;
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : _placeOrder,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child:
                  isLoading
                      ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                      : const Text('Place Order'),
            ),
          );
        },
      ),
    );
  }
}
