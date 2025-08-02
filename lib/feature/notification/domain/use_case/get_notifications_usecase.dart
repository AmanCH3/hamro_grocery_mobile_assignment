import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/notification/domain/entity/notification_entity.dart';
import 'package:hamro_grocery_mobile/feature/notification/domain/repository/notification_repository.dart';

// FINAL FIX: Implement UseCaseWithoutParams
class GetNotificationsUseCase
    implements UseCaseWithoutParams<List<NotificationEntity>> {
  final INotificationRepository _notificationRepository;

  GetNotificationsUseCase(this._notificationRepository);

  @override
  // FINAL FIX: The call method takes no parameters
  Future<Either<Failure, List<NotificationEntity>>> call() async {
    return await _notificationRepository.getNotifications();
  }
}
