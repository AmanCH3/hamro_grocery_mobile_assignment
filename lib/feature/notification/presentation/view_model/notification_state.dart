import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/feature/notification/domain/entity/notification_entity.dart';

class NotificationState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationState({
    this.isLoading = false,
    this.error,
    this.notifications = const [],
    this.unreadCount = 0,
  });

  NotificationState copyWith({
    bool? isLoading,
    String? error,
    List<NotificationEntity>? notifications,
    int? unreadCount,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, notifications, unreadCount];
}
