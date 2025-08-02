import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/notification/domain/repository/notification_repository.dart';

// FINAL FIX: Implement UseCaseWithoutParams
class MarkAsReadUseCase implements UseCaseWithoutParams<bool> {
  final INotificationRepository _notificationRepository;

  MarkAsReadUseCase(this._notificationRepository);

  @override
  // FINAL FIX: The call method takes no parameters
  Future<Either<Failure, bool>> call() async {
    return await _notificationRepository.markAsRead();
  }
}
