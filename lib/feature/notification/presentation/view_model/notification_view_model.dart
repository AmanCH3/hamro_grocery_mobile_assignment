import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/feature/notification/domain/use_case/get_notifications_usecase.dart';
import 'package:hamro_grocery_mobile/feature/notification/domain/use_case/mark_as_read_usecase.dart';
import 'package:hamro_grocery_mobile/feature/notification/presentation/view_model/notification_event.dart';
import 'package:hamro_grocery_mobile/feature/notification/presentation/view_model/notification_state.dart';

class NotificationViewModel extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkAsReadUseCase _markAsReadUseCase;

  NotificationViewModel(this._getNotificationsUseCase, this._markAsReadUseCase)
    : super(const NotificationState()) {
    on<GetNotificationsEvent>(_onGetNotifications);
    on<MarkAsReadEvent>(_onMarkAsRead);
  }

  void _onGetNotifications(
    GetNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _getNotificationsUseCase();

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.message)),
      (notifications) {
        final unreadCount = notifications.where((n) => !n.read).toList().length;
        emit(
          state.copyWith(
            isLoading: false,
            notifications: notifications,
            unreadCount: unreadCount,
          ),
        );
      },
    );
  }

  void _onMarkAsRead(
    MarkAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _markAsReadUseCase();

    result.fold(
      (failure) {
        print('Failed to mark notifications as read: ${failure.message}');
        // If marking fails, we still fetch the notifications
        add(GetNotificationsEvent());
      },
      (success) {
        // If successful, refetch the notifications to update the UI
        add(GetNotificationsEvent());
      },
    );
  }
}
