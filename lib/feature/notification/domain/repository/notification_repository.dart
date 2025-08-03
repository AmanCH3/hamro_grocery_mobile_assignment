import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/feature/notification/domain/entity/notification_entity.dart';

import '../../../../core/error/failure.dart';

abstract class INotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, bool>> markAsRead();
}
