// e.g., in test/feature/notification/mock_repository.dart
import 'package:mocktail/mocktail.dart';
import 'package:hamro_grocery_mobile/feature/notification/domain/repository/notification_repository.dart';

class MockNotificationRepository extends Mock
    implements INotificationRepository {}
