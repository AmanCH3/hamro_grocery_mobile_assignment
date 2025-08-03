import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/cart_event.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/cart_view_model.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/order_event.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/order_state.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/order_view_model.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/payment_event.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/payment_state.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/payment_view_model.dart';
import 'package:intl/intl.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

// Enum to manage payment method selection
enum PaymentMethod { cod, khalti }

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
  PaymentMethod _paymentMethod = PaymentMethod.cod;

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// This function is the entry point when the user clicks the final button.
  void _processOrder() {
    // 1. Validate the form before proceeding.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 2. Based on the selected payment method, dispatch the correct event.
    if (_paymentMethod == PaymentMethod.cod) {
      // For Cash on Delivery, dispatch to the original OrderBloc.
      context.read<OrderBloc>().add(
        CreateOrder(
          items: widget.items,
          address: _addressController.text.trim(),
          phone: _phoneController.text.trim(),
          applyDiscount: _applyDiscount,
        ),
      );
    } else {
      // For Khalti, start the payment flow by dispatching to PaymentBloc.
      // This will call our backend to get the payment identifier (pidx).
      context.read<PaymentBloc>().add(
        KhaltiPaymentStarted(
          items: widget.items,
          address: _addressController.text.trim(),
          phone: _phoneController.text.trim(),
          applyDiscount: _applyDiscount,
        ),
      );
    }
  }

  /// This helper method launches the Khalti SDK's UI.
  /// It should only be called *after* our backend has successfully initiated the payment
  /// and returned a `pidx`.
  void _launchKhalti(String pidx) {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount:
            (widget.totalPrice * 100).round(), // Amount in paisa for display
        productIdentity: pidx, // Use the PIDX from your server
        productName: 'Hamro Grocery Order',
      ),
      // This function is called after the user successfully completes the payment in Khalti's UI.
      onSuccess: (PaymentSuccessModel success) {
        // Now, we must verify this payment on our server.
        // We use the pidx from the success model as it's the source of truth.
        context.read<PaymentBloc>().add(
          KhaltiPaymentVerified(pidx: success.idx),
        );
      },
      // This function is called if the user cancels or if an error occurs within Khalti's UI.
      onFailure: (PaymentFailureModel failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message), backgroundColor: Colors.red),
        );
      },
      onCancel: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment Cancelled'),
            backgroundColor: Colors.orange,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // A MultiBlocListener is perfect for handling side effects from multiple BLoCs on one screen.
    return MultiBlocListener(
      listeners: [
        // Listener for the original OrderBloc (handles COD success/failure).
        BlocListener<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state.status == OrderRequestStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order placed successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<CartBloc>().add(ClearCart());
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else if (state.status == OrderRequestStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Failed to place order.'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
        ),
        // Listener for the new PaymentBloc (handles all Khalti steps).
        BlocListener<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state.status == PaymentStatus.initiationSuccess) {
              // The backend has given us the pidx, now it's time to launch Khalti's UI.
              _launchKhalti(state.pidx!);
            } else if (state.status == PaymentStatus.initiationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? 'Could not start payment.',
                  ),
                  backgroundColor: Colors.redAccent,
                ),
              );
            } else if (state.status == PaymentStatus.verificationSuccess) {
              // The backend has verified the payment. The order is now complete!
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment successful & order placed!'),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<CartBloc>().add(ClearCart());
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else if (state.status == PaymentStatus.verificationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? 'Payment verification failed.',
                  ),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Confirm Order'), centerTitle: true),
        body: SingleChildScrollView(
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
                  validator:
                      (value) =>
                          (value == null || value.trim().isEmpty)
                              ? 'Please enter your delivery address'
                              : null,
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
                  validator:
                      (value) =>
                          (value == null || value.trim().length < 10)
                              ? 'Please enter a valid phone number'
                              : null,
                ),
                const SizedBox(height: 24),
                _buildSectionHeader('Payment Method'),
                RadioListTile<PaymentMethod>(
                  title: const Text('Cash on Delivery'),
                  value: PaymentMethod.cod,
                  groupValue: _paymentMethod,
                  onChanged: (value) => setState(() => _paymentMethod = value!),
                  activeColor: Colors.teal,
                ),
                RadioListTile<PaymentMethod>(
                  title: const Text('Pay with Khalti'),
                  value: PaymentMethod.khalti,
                  groupValue: _paymentMethod,
                  onChanged: (value) => setState(() => _paymentMethod = value!),
                  activeColor: Colors.teal,
                ),
                const SizedBox(height: 24),
                _buildSectionHeader('Member Perks'),
                SwitchListTile(
                  title: const Text('Apply 25% Member Discount'),
                  subtitle: const Text('Uses 150 loyalty points'),
                  value: _applyDiscount,
                  onChanged: (value) => setState(() => _applyDiscount = value),
                  secondary: const Icon(Icons.star_border),
                  activeColor: Colors.teal,
                ),
                const SizedBox(height: 24),
                _buildSectionHeader('Order Summary'),
                _buildOrderSummaryCard(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildPlaceOrderButton(),
      ),
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
      // We listen to both BLoCs to determine the overall loading state.
      child: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, paymentState) {
          return BlocBuilder<OrderBloc, OrderState>(
            builder: (context, orderState) {
              final isPaymentLoading =
                  paymentState.status == PaymentStatus.loading;
              final isOrderLoading =
                  orderState.status == OrderRequestStatus.loading;
              final isLoading = isPaymentLoading || isOrderLoading;

              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _processOrder,
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
                          : Text(
                            _paymentMethod == PaymentMethod.cod
                                ? 'Place Order'
                                : 'Pay with Khalti',
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
