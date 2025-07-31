import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view/signup_page.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterViewModel extends MockBloc<RegisterEvent, RegisterState>
    implements RegisterViewModel {}

void registerFallbackValues() {
  registerFallbackValue(
    RegisterUserEvent(
      context: MockBuildContext(),
      fullName: '',
      email: '',
      password: '',
    ),
  );
}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockRegisterViewModel mockRegisterViewModel;

  setUp(() {
    mockRegisterViewModel = MockRegisterViewModel();

    when(
      () => mockRegisterViewModel.state,
    ).thenReturn(const RegisterState(isLoading: true, isSuccess: true));
    registerFallbackValues();
  });

  Widget createWidgetUnderTest() {
    return BlocProvider<RegisterViewModel>(
      create: (_) => mockRegisterViewModel,
      child: const MaterialApp(home: SignUpPage()),
    );
  }

  group('SignUpPage', () {
    testWidgets('should render all initial UI elements correctly', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Full Name'), findsOneWidget);
      expect(
        find.widgetWithText(TextFormField, 'Email Address'),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
      expect(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        findsOneWidget,
      );
      expect(find.widgetWithText(ElevatedButton, 'SIGN UP'), findsOneWidget);
      expect(find.text('Already have an account? '), findsOneWidget);
    });

    testWidgets('should show CircularProgressIndicator when state is loading', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockRegisterViewModel.state,
      ).thenReturn(const RegisterState(isLoading: true, isSuccess: true));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
