// test/feature/notification/presentation/view_model/mock_notification_usecases.dart
import 'package:mocktail/mocktail.dart';
import 'package:hamro_grocery_mobile/feature/notification/domain/use_case/get_notifications_usecase.dart';
import 'package:hamro_grocery_mobile/feature/notification/domain/use_case/mark_as_read_usecase.dart';

class MockGetNotificationsUseCase extends Mock
    implements GetNotificationsUseCase {}

class MockMarkAsReadUseCase extends Mock implements MarkAsReadUseCase {}
