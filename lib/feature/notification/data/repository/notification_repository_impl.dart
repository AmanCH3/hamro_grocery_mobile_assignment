import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/notification/data/data_source/notification_remote_data_source.dart';
import 'package:hamro_grocery_mobile/feature/notification/domain/entity/notification_entity.dart';
import 'package:hamro_grocery_mobile/feature/notification/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements INotificationRepository {
  final NotificationRemoteDataSource _notificationRemoteDataSource;

  NotificationRepositoryImpl(this._notificationRemoteDataSource);

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    final result = await _notificationRemoteDataSource.getNotifications();
    return result.fold((failure) => Left(failure), (notifications) {
      final notificationEntities =
          notifications
              .map((model) => NotificationEntity.fromApiModel(model))
              .toList();
      return Right(notificationEntities);
    });
  }

  @override
  Future<Either<Failure, bool>> markAsRead() {
    return _notificationRemoteDataSource.markAsRead();
  }
}
