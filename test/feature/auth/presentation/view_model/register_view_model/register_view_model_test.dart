import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/usecase/register_usecase.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:mocktail/mocktail.dart';

// Use case mock
class MockUserRegisterUseCase extends Mock implements UserRegisterUseCase {}

// BuildContext mock
class MockBuildContext extends Mock implements BuildContext {}

void main() {
  // 1. Declare Mocks and BLoC variables
  late MockUserRegisterUseCase mockUserRegisterUseCase;
  late RegisterViewModel registerViewModel;
  late MockBuildContext mockBuildContext;

  // 2. Prepare reusable test data
  const tFullName = 'Test User';
  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  final tFailure = ApiFailure(message: 'Email already exists');

  setUp(() {
    // 3. Instantiate mocks and the BLoC
    mockUserRegisterUseCase = MockUserRegisterUseCase();
    mockBuildContext = MockBuildContext();
    registerViewModel = RegisterViewModel(mockUserRegisterUseCase);
    registerFallbackValue(
      const RegisterUserParams(fullName: '', email: '', password: ''),
    );
    // Stub the BuildContext's `mounted` property to return true for tests
    when(() => mockBuildContext.mounted).thenReturn(true);
  });

  tearDown(() {
    registerViewModel.close();
  });

  group('RegisterViewModel', () {
    test('initial state is RegisterState.initial()', () {
      expect(registerViewModel.state, const RegisterState.initial());
    });

    group('RegisterUserEvent', () {
      // Create a reusable event with the mock context
      final tRegisterEvent = RegisterUserEvent(
        context: mockBuildContext,
        fullName: tFullName,
        email: tEmail,
        password: tPassword,
      );

      blocTest<RegisterViewModel, RegisterState>(
        'emits [loading, success] when UserRegisterUseCase is successful',
        setUp: () {
          // Arrange: When the use case is called, return success (Right with void/unit)
          when(
            () => mockUserRegisterUseCase(any()),
          ).thenAnswer((_) async => const Right(unit));
        },
        build: () => registerViewModel,
        act: (bloc) => bloc.add(tRegisterEvent),
        expect:
            () => <RegisterState>[
              // 1. First state: loading is true
              const RegisterState(isLoading: true, isSuccess: false),
              // 2. Second state: loading is false, success is true
              const RegisterState(isLoading: false, isSuccess: true),
            ],
        verify: (_) {
          // Verify the use case was called with the exact data from the event
          verify(
            () => mockUserRegisterUseCase(
              const RegisterUserParams(
                fullName: tFullName,
                email: tEmail,
                password: tPassword,
              ),
            ),
          ).called(1);
        },
      );

      blocTest<RegisterViewModel, RegisterState>(
        'emits [loading, not success] when UserRegisterUseCase fails',
        setUp: () {
          // Arrange: Stub the use case to return a failure
          when(
            () => mockUserRegisterUseCase(any()),
          ).thenAnswer((_) async => Left(tFailure));
        },
        build: () => registerViewModel,
        act: (bloc) => bloc.add(tRegisterEvent),
        expect:
            () => <RegisterState>[
              // 1. First state: loading is true
              const RegisterState(isLoading: true, isSuccess: false),
              // 2. Second state: loading is false, success remains false
              const RegisterState(isLoading: false, isSuccess: false),
            ],
        verify: (_) {
          // Verify the use case was still called correctly
          verify(() => mockUserRegisterUseCase(any())).called(1);
        },
      );
    });

    group('NavigateToLoginEvent', () {
      // NOTE: This test addresses a BLoC with side effects.
      // The ideal BLoC would emit a state like `NavigateToLoginSuccess`, and the UI
      // would listen with a BlocListener to perform navigation.
      // Since this BLoC performs navigation directly, we can only test that it
      // *doesn't* change the state, as `bloc_test` is for state stream verification.
      blocTest<RegisterViewModel, RegisterState>(
        'does not emit any new states',
        build: () => registerViewModel,
        act:
            (bloc) => bloc.add(NavigateToLoginEvent(context: mockBuildContext)),
        // The `expect` block is empty because this event handler does not `emit`.
        expect: () => const <RegisterState>[],
      );
    });
  });
}
