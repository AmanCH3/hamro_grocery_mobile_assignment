import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/app/service_locator/service_locator.dart';
import 'package:hamro_grocery_mobile/feature/notification/presentation/view_model/notification_event.dart';
import 'package:hamro_grocery_mobile/feature/notification/presentation/view_model/notification_state.dart';
import 'package:hamro_grocery_mobile/feature/notification/presentation/view_model/notification_view_model.dart';

import 'package:intl/intl.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // FINAL FIX: Dispatch MarkAsReadEvent when the screen opens
      create:
          (context) =>
              serviceLocator<NotificationViewModel>()..add(MarkAsReadEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          // The manual button is no longer needed
        ),
        body: BlocBuilder<NotificationViewModel, NotificationState>(
          builder: (context, state) {
            // We can show a loading indicator even while marking as read
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null) {
              return Center(child: Text('Error: ${state.error}'));
            }

            if (state.notifications.isEmpty) {
              return const Center(child: Text('You have no notifications.'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                // The user can still pull to refresh
                context.read<NotificationViewModel>().add(
                  GetNotificationsEvent(),
                );
              },
              child: ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  // Since the list is refreshed after marking, all should be 'read'
                  final isRead = notification.read;
                  final timeAgo = _formatTimeAgo(notification.createdAt);

                  return Container(
                    // You can remove the color change if you prefer
                    color:
                        isRead
                            ? Colors.transparent
                            : Colors.blue.withOpacity(0.05),
                    child: ListTile(
                      leading: Icon(
                        Icons.notifications_none, // Always show the 'read' icon
                        color: Colors.grey,
                      ),
                      title: Text(notification.message),
                      subtitle: Text(timeAgo),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, y').format(dateTime);
    }
  }
}
