import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/notification/domain/use_case/mark_as_read_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_repository.dart';

void main() {
  // 1. Declare variables
  late MockNotificationRepository mockNotificationRepository;
  late MarkAsReadUseCase usecase;

  setUp(() {
    // 2. Instantiate mocks and the usecase before each test
    mockNotificationRepository = MockNotificationRepository();
    usecase = MarkAsReadUseCase(mockNotificationRepository);
  });

  // 3. Prepare reusable test data
  final tFailure = ApiFailure(message: 'Failed to mark notifications as read');
  const tSuccessResult = true;

  group('MarkAsReadUseCase', () {
    test(
      'should call markAsRead on the repository and return true on success',
      () async {
        // Arrange
        // Stub the repository method to return a successful boolean result
        when(
          () => mockNotificationRepository.markAsRead(),
        ).thenAnswer((_) async => const Right(tSuccessResult));

        // Act
        // Call the usecase (no parameters are needed)
        final result = await usecase();

        // Assert
        // Expect the result to be a successful Right(true)
        expect(result, const Right(tSuccessResult));
        // Verify that the repository's markAsRead method was called exactly once
        verify(() => mockNotificationRepository.markAsRead()).called(1);
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
          () => mockNotificationRepository.markAsRead(),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase();

        // Assert
        // Expect the result to be the defined Failure
        expect(result, Left(tFailure));
        // Verify that the repository's method was still called
        verify(() => mockNotificationRepository.markAsRead()).called(1);
        // Ensure no other interactions
        verifyNoMoreInteractions(mockNotificationRepository);
      },
    );
  });
}
