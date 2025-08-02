// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hamro_grocery_mobile/app/service_locator/service_locator.dart';
// import 'package:hamro_grocery_mobile/feature/notification/domain/entity/notification_entity.dart';
// import 'package:hamro_grocery_mobile/feature/notification/presentation/view/notification_screen.dart';
// import 'package:hamro_grocery_mobile/feature/notification/presentation/view_model/notification_event.dart';
// import 'package:hamro_grocery_mobile/feature/notification/presentation/view_model/notification_state.dart';
// import 'package:hamro_grocery_mobile/feature/notification/presentation/view_model/notification_view_model.dart';
// import 'package:mocktail/mocktail.dart';

// // Import your mock view model
// class MockNotificationViewModel
//     extends MockBloc<NotificationEvent, NotificationState>
//     implements NotificationViewModel {}

// void main() {
//   // 1. Declare the Mock BLoC
//   late MockNotificationViewModel mockNotificationViewModel;

//   // 2. Prepare reusable test data
//   final tNotificationList = [
//     NotificationEntity(
//       id: '1',
//       message: 'Your order has shipped!',
//       read: true,
//       createdAt: DateTime.now(),
//     ),
//     NotificationEntity(
//       id: '2',
//       message: 'A new promotion is available.',
//       read: true,
//       createdAt: DateTime.now().subtract(const Duration(hours: 2)),
//     ),
//   ];

//   // 3. Set up mocks and the service locator before each test
//   setUp(() {
//     mockNotificationViewModel = MockNotificationViewModel();

//     // IMPORTANT: Intercept the serviceLocator call to provide our mock.
//     // This is the standard way to test widgets that use a global locator.
//     if (serviceLocator.isRegistered<NotificationViewModel>()) {
//       serviceLocator.unregister<NotificationViewModel>();
//     }
//     serviceLocator.registerFactory<NotificationViewModel>(
//       () => mockNotificationViewModel,
//     );

//     // Provide a default state for the mock BLoC to avoid null errors.
//     when(
//       () => mockNotificationViewModel.state,
//     ).thenReturn(const NotificationState());
//     // Stub the `add` method since it's called in the `create` callback.
//     when(() => mockNotificationViewModel.add(any())).thenAnswer((_) async {});
//   });

//   tearDown(() {
//     // Clean up the service locator after each test to prevent side effects.
//     serviceLocator.unregister<NotificationViewModel>();
//   });

//   // Helper function to build the widget within a testable environment.
//   Future<void> pumpScreen(WidgetTester tester) async {
//     await tester.pumpWidget(const MaterialApp(home: NotificationScreen()));
//   }

//   group('NotificationScreen', () {
//     testWidgets('dispatches MarkAsReadEvent when the screen is first built', (
//       tester,
//     ) async {
//       // Act: Build the screen.
//       await pumpScreen(tester);

//       // Assert: Verify that the `create` callback of the BlocProvider called `add` with the correct event.
//       verify(
//         () => mockNotificationViewModel.add(any(that: isA<MarkAsReadEvent>())),
//       ).called(1);
//     });

//     testWidgets('shows CircularProgressIndicator when state is loading', (
//       tester,
//     ) async {
//       // Arrange: Force the mock BLoC to be in a loading state.
//       when(
//         () => mockNotificationViewModel.state,
//       ).thenReturn(const NotificationState(isLoading: true));

//       // Act
//       await pumpScreen(tester);

//       // Assert
//       expect(find.byType(CircularProgressIndicator), findsOneWidget);
//       expect(find.byType(ListView), findsNothing);
//     });

//     testWidgets('shows error message when state has an error', (tester) async {
//       // Arrange
//       const errorMessage = 'Network failed';
//       when(
//         () => mockNotificationViewModel.state,
//       ).thenReturn(const NotificationState(error: errorMessage));

//       // Act
//       await pumpScreen(tester);

//       // Assert
//       expect(find.text('Error: $errorMessage'), findsOneWidget);
//     });

//     testWidgets(
//       'shows "no notifications" message when list is empty and not loading/error',
//       (tester) async {
//         // Arrange
//         when(
//           () => mockNotificationViewModel.state,
//         ).thenReturn(const NotificationState(notifications: []));

//         // Act
//         await pumpScreen(tester);
//         await tester.pump(); // Allow UI to settle

//         // Assert
//         expect(find.text('You have no notifications.'), findsOneWidget);
//       },
//     );

//     testWidgets('displays a list of notifications when data is available', (
//       tester,
//     ) async {
//       // Arrange
//       when(
//         () => mockNotificationViewModel.state,
//       ).thenReturn(NotificationState(notifications: tNotificationList));

//       // Act
//       await pumpScreen(tester);
//       await tester.pump();

//       // Assert
//       expect(find.byType(ListView), findsOneWidget);
//       expect(find.byType(ListTile), findsNWidgets(tNotificationList.length));
//       expect(find.text('Your order has shipped!'), findsOneWidget);
//       expect(find.text('A new promotion is available.'), findsOneWidget);
//     });

//     testWidgets('dispatches GetNotificationsEvent when pulled to refresh', (
//       tester,
//     ) async {
//       // Arrange
//       when(
//         () => mockNotificationViewModel.state,
//       ).thenReturn(NotificationState(notifications: tNotificationList));

//       // Act
//       await pumpScreen(tester);
//       await tester.pump();

//       // To test RefreshIndicator programmatically, we find the widget and call its `onRefresh` callback.
//       final refreshIndicator = tester.widget<RefreshIndicator>(
//         find.byType(RefreshIndicator),
//       );
//       await refreshIndicator.onRefresh();

//       await tester.pump(); // Wait for the event to be processed.

//       // Assert: Verify that GetNotificationsEvent was added to the BLoC.
//       verify(
//         () => mockNotificationViewModel.add(
//           any(that: isA<GetNotificationsEvent>()),
//         ),
//       ).called(1);
//     });
//   });
// }
