import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/notification/domain/entity/notification_entity.dart';
import 'package:hamro_grocery_mobile/feature/notification/domain/use_case/get_notifications_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_repository.dart';

void main() {
  late MockNotificationRepository mockNotificationRepository;
  late GetNotificationsUseCase usecase;

  setUp(() {
    mockNotificationRepository = MockNotificationRepository();
    usecase = GetNotificationsUseCase(mockNotificationRepository);
  });

  final tNotificationList = [
    NotificationEntity(
      id: '1',
      message:
          'Your order #123 has been shipped.', // Use 'message' instead of 'title' and 'body'
      createdAt: DateTime.now(),
      read: false, // Use 'read' instead of 'isRead'
    ),
    NotificationEntity(
      id: '2',
      message: 'Special Offer! Get 20% off on all fruits.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      read: true,
    ),
  ];
  // --- END OF CORRECTION ---

  final tFailure = ApiFailure(message: 'Could not fetch notifications');

  group('GetNotificationsUseCase', () {
    test(
      'should get a list of notifications from the repository successfully',
      () async {
        // Arrange
        // Stub the repository method to return a successful list of notifications
        when(
          () => mockNotificationRepository.getNotifications(),
        ).thenAnswer((_) async => Right(tNotificationList));

        // Act
        // Call the usecase (no parameters are needed)
        final result = await usecase();

        // Assert
        // Expect the result to be the successful list
        expect(result, Right(tNotificationList));
        // Verify that the repository's getNotifications method was called exactly once
        verify(() => mockNotificationRepository.getNotifications()).called(1);
        // Ensure no other methods on the repository were called
        verifyNoMoreInteractions(mockNotificationRepository);
      },
    );

    test(
      'should return a Failure when the call to the repository is unsuccessful',
      () async {
        // Arrange
        // Stub the repository method to return a failure
        when(
          () => mockNotificationRepository.getNotifications(),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase();

        // Assert
        // Expect the result to be the defined Failure
        expect(result, Left(tFailure));
        // Verify that the repository's method was still called
        verify(() => mockNotificationRepository.getNotifications()).called(1);
        // Ensure no other interactions
        verifyNoMoreInteractions(mockNotificationRepository);
      },
    );
  });
}
