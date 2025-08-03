// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hamro_grocery_mobile/app/service_locator/service_locator.dart';
// import 'package:hamro_grocery_mobile/feature/notification/domain/entity/notification_entity.dart';
// import 'package:hamro_grocery_mobile/feature/notification/presentation/view/notification_screen.dart';
// import 'package:hamro_grocery_mobile/feature/notification/presentation/view_model/notification_event.dart';
// import 'package:hamro_grocery_mobile/feature/notification/presentation/view_model/notification_state.dart';
// import 'package:hamro_grocery_mobile/feature/notification/presentation/view_model/notification_view_model.dart';
// import 'package:mocktail/mocktail.dart';

// // Import the mock view model created in step 1
// class MockNotificationViewModel
//     extends MockBloc<NotificationEvent, NotificationState>
//     implements NotificationViewModel {}

// void main() {
//   late MockNotificationViewModel mockNotificationViewModel;

//   // Since NotificationEvent doesn't have complex parameters,
//   // registerFallbackValues() is not needed for this test.

//   // Reusable test data
//   final tNotificationList = [
//     NotificationEntity(
//       id: '1',
//       message: 'First test notification',
//       read: true,
//       createdAt: DateTime.now(),
//     ),
//     NotificationEntity(
//       id: '2',
//       message: 'Second test notification',
//       read: true,
//       createdAt: DateTime.now(),
//     ),
//   ];

//   setUp(() {
//     mockNotificationViewModel = MockNotificationViewModel();

//     // Key Step: Mock the service locator to return our mock BLoC
//     if (serviceLocator.isRegistered<NotificationViewModel>()) {
//       serviceLocator.unregister<NotificationViewModel>();
//     }
//     serviceLocator.registerFactory<NotificationViewModel>(
//       () => mockNotificationViewModel,
//     );

//     // Provide a default state to avoid null state errors
//     when(
//       () => mockNotificationViewModel.state,
//     ).thenReturn(const NotificationState());
//     // Stub the `add` method, which is called in the create callback
//     when(() => mockNotificationViewModel.add(any())).thenAnswer((_) async {});
//   });

//   tearDown(() {
//     serviceLocator.unregister<NotificationViewModel>();
//   });

//   // Helper function similar to the sample's `createWidgetUnderTest`
//   Widget createWidgetUnderTest() {
//     // The BlocProvider is inside NotificationScreen, so we don't need it here.
//     return MaterialApp(home: const NotificationScreen());
//   }

//   group('NotificationScreen', () {
//     testWidgets(
//       'should render initial UI elements and dispatch MarkAsReadEvent',
//       (tester) async {
//         // Arrange
//         await tester.pumpWidget(createWidgetUnderTest());

//         // Assert: Check for static UI elements
//         expect(find.byType(AppBar), findsOneWidget);
//         expect(find.text('Notifications'), findsOneWidget);

//         // Assert: Verify the initial event dispatch from the `create` callback
//         verify(
//           () =>
//               mockNotificationViewModel.add(any(that: isA<MarkAsReadEvent>())),
//         ).called(1);
//       },
//     );

//     testWidgets('should show CircularProgressIndicator when state is loading', (
//       tester,
//     ) async {
//       // Arrange: Force the mock BLoC state to be loading
//       when(
//         () => mockNotificationViewModel.state,
//       ).thenReturn(const NotificationState(isLoading: true));

//       // Act
//       await tester.pumpWidget(createWidgetUnderTest());

//       // Assert
//       expect(find.byType(CircularProgressIndicator), findsOneWidget);
//       // Ensure other UI elements are not present
//       expect(find.byType(ListView), findsNothing);
//       expect(find.text('You have no notifications.'), findsNothing);
//     });

//     testWidgets('should show an error message when state has an error', (
//       tester,
//     ) async {
//       // Arrange
//       const errorMessage = 'Failed to connect';
//       when(
//         () => mockNotificationViewModel.state,
//       ).thenReturn(const NotificationState(error: errorMessage));

//       // Act
//       await tester.pumpWidget(createWidgetUnderTest());

//       // Assert
//       expect(find.text('Error: $errorMessage'), findsOneWidget);
//     });

//     testWidgets('should show "no notifications" message when list is empty', (
//       tester,
//     ) async {
//       // Arrange
//       when(
//         () => mockNotificationViewModel.state,
//       ).thenReturn(const NotificationState(notifications: []));

//       // Act
//       await tester.pumpWidget(createWidgetUnderTest());
//       await tester.pump(); // Let UI settle

//       // Assert
//       expect(find.text('You have no notifications.'), findsOneWidget);
//     });

//     testWidgets(
//       'should display a list of notifications when data is available',
//       (tester) async {
//         // Arrange
//         when(
//           () => mockNotificationViewModel.state,
//         ).thenReturn(NotificationState(notifications: tNotificationList));

//         // Act
//         await tester.pumpWidget(createWidgetUnderTest());
//         await tester.pump();

//         // Assert
//         expect(find.byType(ListView), findsOneWidget);
//         expect(find.byType(ListTile), findsNWidgets(tNotificationList.length));
//         expect(find.text('First test notification'), findsOneWidget);
//         expect(find.text('Second test notification'), findsOneWidget);
//       },
//     );
//   });
// }
