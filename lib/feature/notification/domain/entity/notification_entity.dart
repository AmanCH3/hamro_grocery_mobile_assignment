import 'package:hamro_grocery_mobile/feature/notification/data/model/notification_api_model.dart';

class NotificationEntity {
  final String id;
  final String message;
  final bool read;
  final DateTime createdAt;

  NotificationEntity({
    required this.id,
    required this.message,
    required this.read,
    required this.createdAt,
  });

  factory NotificationEntity.fromApiModel(NotificationApiModel model) {
    return NotificationEntity(
      id: model.id,
      message: model.message,
      read: model.read,
      createdAt: model.createdAt,
    );
  }
}
