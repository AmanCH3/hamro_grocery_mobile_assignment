import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view/order_detail_screen.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/order_event.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/order_state.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/order_view_model.dart';
import 'package:intl/intl.dart';

// This is the main screen that will be shown in your bottom navigation.
// It fetches and displays a list of all orders.
class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the orders when the screen is first loaded.
    context.read<OrderBloc>().add(GetMyOrders());
  }

  @override
  Widget build(BuildContext context) {
    // The Scaffold is removed from here because the main dashboard screen will provide it.
    // This widget will be displayed as the body of the main screen.
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        // Handle the loading state, especially on the first load.
        if (state.status == OrderRequestStatus.loading &&
            state.myOrders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle the failure state.
        if (state.status == OrderRequestStatus.failure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.errorMessage ?? 'An unknown error occurred.'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<OrderBloc>().add(GetMyOrders());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Handle the case where the user has no orders.
        if (state.myOrders.isEmpty) {
          return const Center(
            child: Text(
              'You have no orders yet.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        // Display the list of orders.
        return RefreshIndicator(
          onRefresh: () async {
            context.read<OrderBloc>().add(GetMyOrders());
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: state.myOrders.length,
            itemBuilder: (context, index) {
              final order = state.myOrders[index];
              return _OrderItemCard(order: order);
            },
          ),
        );
      },
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  final OrderEntity order;

  const _OrderItemCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Navigate to the OrderDetailScreen when the card is tapped.
          Navigator.of(context).push(
            MaterialPageRoute(
              // You must provide the specific order to the detail screen.
              builder: (_) => OrderDetailScreen(order: order),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Order #${order.id.substring(0, 8)}...',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _OrderStatusChip(status: order.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Placed on: ${DateFormat.yMMMd().format(order.createdAt)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Divider(height: 24),
              // You can add more details like item count if available in OrderEntity
              // Text('${order.items.length} items'),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Total: \NPR${order.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.teal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
        status.name, // .name gives the string representation of an enum
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      backgroundColor: _getStatusColor(),
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact, // Makes the chip a bit smaller
    );
  }
}
