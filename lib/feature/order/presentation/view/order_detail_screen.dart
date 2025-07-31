import 'package:flutter/material.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order.id.substring(0, 8)}'),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummaryCard(context),
            const SizedBox(height: 16),
            _buildItemsCard(context),
            const SizedBox(height: 16),
            _buildShippingCard(context),
            const SizedBox(height: 16),
            _buildPaymentCard(context),
          ],
        ),
      ),
    );
  }

  // Card for general order information
  Widget _buildOrderSummaryCard(BuildContext context) {
    return _buildSectionCard(
      title: 'Order Summary',
      child: Column(
        children: [
          _DetailRow(
            icon: Icons.confirmation_number_outlined,
            title: 'Order ID',
            value: order.id,
          ),
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            title: 'Date Placed',
            value: DateFormat.yMMMMd().add_jm().format(order.createdAt),
          ),
          _DetailRow(
            icon: Icons.monetization_on_outlined,
            title: 'Total Amount',
            value: '\NPR${order.amount.toStringAsFixed(2)}',
            valueStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.teal,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_shipping_outlined,
                color: Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 16),
              Text('Status', style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              _OrderStatusChip(status: order.status),
            ],
          ),
        ],
      ),
    );
  }

  // Card to list all items in the order
  Widget _buildItemsCard(BuildContext context) {
    return _buildSectionCard(
      title: 'Items (${order.items.length})',
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: order.items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = order.items[index];
          // Assuming OrderItem has these properties. Adjust if your entity is different.
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.shopping_basket_outlined),
            title: Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Quantity: ${item.quantity}'),
            trailing: Text(
              '\$${(item.price * item.quantity).toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          );
        },
      ),
    );
  }

  // Card for shipping and contact info
  Widget _buildShippingCard(BuildContext context) {
    return _buildSectionCard(
      title: 'Shipping Details',
      child: Column(
        children: [
          _DetailRow(
            icon: Icons.home_outlined,
            title: 'Address',
            value: order.address,
          ),
          _DetailRow(
            icon: Icons.phone_outlined,
            title: 'Contact Phone',
            value: order.phone,
          ),
        ],
      ),
    );
  }

  // Card for payment details
  Widget _buildPaymentCard(BuildContext context) {
    return _buildSectionCard(
      title: 'Payment Details',
      child: Column(
        children: [
          _DetailRow(
            icon: Icons.payment_outlined,
            title: 'Payment Method',
            value: order.paymentMethod,
          ),
          _DetailRow(
            icon: Icons.local_offer_outlined,
            title: 'Discount Applied',
            value: order.discountApplied ? 'Yes' : 'No',
          ),
          _DetailRow(
            icon: Icons.star_border_outlined,
            title: 'Points Awarded',
            value: '${order.pointsAwarded} points',
          ),
        ],
      ),
    );
  }

  // A helper widget to create a consistent card structure for each section
  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20, thickness: 1),
            child,
          ],
        ),
      ),
    );
  }
}

// A reusable row for displaying a title and a value
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final TextStyle? valueStyle;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 16),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style:
                  valueStyle ??
                  Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}

// You can keep this chip here or move it to a shared file
class _OrderStatusChip extends StatelessWidget {
  final OrderStatus status;

  const _OrderStatusChip({required this.status});

  Color _getStatusColor() {
    switch (status) {
      case OrderStatus.Delivered:
        return Colors.green;
      case OrderStatus.Shipped:
        return Colors.blue;
      case OrderStatus.Processing:
        return Colors.orange;
      case OrderStatus.Cancelled:
        return Colors.red;
      case OrderStatus.Pending:
      case OrderStatus.PendingPayment:
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        status.name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      backgroundColor: _getStatusColor(),
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
