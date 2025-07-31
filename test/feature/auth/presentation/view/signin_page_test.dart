import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view/signin_page.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:mocktail/mocktail.dart';

// --- Mocks and Setup ---
class MockLoginViewModel extends MockBloc<LoginEvent, LoginState>
    implements LoginViewModel {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockLoginViewModel mockLoginViewModel;

  setUp(() {
    mockLoginViewModel = MockLoginViewModel();
    registerFallbackValue(
      LoginWithEmailAndPassword(
        email: '',
        password: '',
        context: MockBuildContext(),
      ),
    );
  });

  // Helper to build the widget tree with our mock BLoC
  Widget createWidgetUnderTest() {
    return BlocProvider<LoginViewModel>.value(
      value: mockLoginViewModel, // <-- We inject the MOCK here
      child: const MaterialApp(home: SignInPage()),
    );
  }

  // --- Test Cases ---

  group('Test Case 1: Initial UI Rendering', () {
    testWidgets('should display all static UI elements correctly', (
      tester,
    ) async {
      // Arrange
      when(() => mockLoginViewModel.state).thenReturn(LoginState.initial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.text('Sign in to continue shopping'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'SIGN IN'), findsOneWidget);
    });
  });

  group('Test Case 2: Validation Logic', () {
    testWidgets('should show SnackBar when login is tapped with empty fields', (
      tester,
    ) async {
      // Arrange
      when(() => mockLoginViewModel.state).thenReturn(LoginState.initial());
      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      await tester.tap(find.widgetWithText(ElevatedButton, 'SIGN IN'));
      await tester.pump(); // Let the SnackBar build

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Please fill in all fields'), findsOneWidget);
      verifyNever(
        () =>
            mockLoginViewModel.add(any(that: isA<LoginWithEmailAndPassword>())),
      );
    });
  });

  group('Test Case 3: Successful Event Dispatch', () {
    testWidgets(
      'should add LoginWithEmailAndPassword event when form is valid',
      (tester) async {
        // Arrange
        when(() => mockLoginViewModel.state).thenReturn(LoginState.initial());
        await tester.pumpWidget(createWidgetUnderTest());
        const email = 'test@example.com';
        const password = 'password123';

        // Act
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'),
          email,
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'),
          password,
        );
        await tester.tap(find.widgetWithText(ElevatedButton, 'SIGN IN'));

        // Assert
        verify(
          () => mockLoginViewModel.add(
            any(
              that: isA<LoginWithEmailAndPassword>()
                  .having((e) => e.email, 'email', email)
                  .having((e) => e.password, 'password', password),
            ),
          ),
        ).called(1);
      },
    );
  });

  group('Test Case 4: Loading State UI', () {
    testWidgets(
      'should show CircularProgressIndicator and disable button when loading',
      (tester) async {
        // Arrange
        whenListen(
          mockLoginViewModel,
          Stream.fromIterable([LoginState(isLoading: true, isSuccess: true)]),
          initialState: LoginState.initial(),
        );

        // Act
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump(); // Process the new state

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(button.onPressed, isNull);
      },
    );
  });

  group('Test Case 5: Password Visibility Toggle', () {
    testWidgets('should toggle password visibility on icon tap', (
      tester,
    ) async {
      // Arrange
      when(() => mockLoginViewModel.state).thenReturn(LoginState.initial());
      await tester.pumpWidget(createWidgetUnderTest());
      final passwordField = find.widgetWithText(TextFormField, 'Password');

      // Assert: Initially obscured
      expect(tester.widget<TextFormField>(passwordField), isTrue);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Act
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump(); // Rebuilds the StatefulBuilder

      // Assert: Now visible
      expect(tester.widget<TextFormField>(passwordField), isFalse);
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });
  });
}
