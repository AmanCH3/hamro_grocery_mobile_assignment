import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/bot/domain/entity/bot_entity.dart';
import 'package:hamro_grocery_mobile/feature/bot/domain/usecase/get_chat_reply_usecase.dart';
import 'package:hamro_grocery_mobile/feature/bot/presentation/view_model/bot_event.dart';
import 'package:hamro_grocery_mobile/feature/bot/presentation/view_model/bot_state.dart';
import 'package:hamro_grocery_mobile/feature/bot/presentation/view_model/bot_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockGetChatReplyUsecase extends Mock implements GetChatReplyUsecase {}

void main() {
  // 1. Declare Mocks and BLoC variables
  late MockGetChatReplyUsecase mockGetChatReplyUsecase;
  late ChatBloc chatBloc;

  // 2. Prepare reusable test data
  final tWelcomeMessage = ChatMessageEntity(
    role: ChatRole.model,
    text:
        "Hello! I'm GrocerBot, your friendly shopping assistant. How can I help you today?",
  );
  const tUserQuery = "Do you have fresh apples?";
  final tUserMessage = ChatMessageEntity(role: ChatRole.user, text: tUserQuery);
  final tBotReply = ChatMessageEntity(
    role: ChatRole.model,
    text: "Yes, we have fresh apples in aisle 3!",
  );
  final tFailure = ApiFailure(message: "I am unable to connect right now.");
  final tErrorReply = ChatMessageEntity(
    role: ChatRole.model,
    text: "Oops! Something went wrong. ${tFailure.message}",
  );

  setUp(() {
    // 3. Instantiate mocks and register fallbacks
    mockGetChatReplyUsecase = MockGetChatReplyUsecase();
    chatBloc = ChatBloc(getChatReplyUsecase: mockGetChatReplyUsecase);

    // Register a fallback value for the custom GetChatReplyParams class
    registerFallbackValue(const GetChatReplyParams(query: '', history: []));
  });

  tearDown(() {
    chatBloc.close();
  });

  group('ChatBloc', () {
    test('initial state is ChatInitial', () {
      // The initial state in your provided code is "TrailMate", but the BLoC's
      // _onInitializeChat sets its own "GrocerBot" message. We test the BLoC's behavior.
      expect(chatBloc.state, isA<ChatInitial>());
    });

    group('InitializeChat Event', () {
      blocTest<ChatBloc, BotState>(
        'emits [ChatLoaded] with the correct welcome message',
        build: () => chatBloc,
        act: (bloc) => bloc.add(InitializeChat()),
        expect:
            () => [
              ChatLoaded(messages: [tWelcomeMessage]),
            ],
        verify: (_) {
          // Verify that the use case was not called for the initial message
          verifyNever(() => mockGetChatReplyUsecase(any()));
        },
      );
    });

    group('SendChatMessage Event', () {
      // Use the welcome message as the starting history for these tests
      final tInitialHistory = [tWelcomeMessage];

      blocTest<ChatBloc, BotState>(
        'emits [ChatLoading, ChatLoaded] with user message and bot reply on success',
        setUp: () {
          // Arrange: When the use case is called, return a successful bot reply
          when(
            () => mockGetChatReplyUsecase(any()),
          ).thenAnswer((_) async => Right(tBotReply));
        },
        build: () => chatBloc,
        // Start the BLoC in a known state with the welcome message
        seed: () => ChatLoaded(messages: tInitialHistory),
        act: (bloc) => bloc.add(const SendChatMessage(query: tUserQuery)),
        expect:
            () => [
              // 1. Optimistic state: show user's message immediately while loading
              ChatLoading(messages: [...tInitialHistory, tUserMessage]),
              // 2. Final state: show the bot's reply
              ChatLoaded(
                messages: [...tInitialHistory, tUserMessage, tBotReply],
              ),
            ],
        verify: (_) {
          // Verify the use case was called with the correct query and history
          verify(
            () => mockGetChatReplyUsecase(
              GetChatReplyParams(query: tUserQuery, history: tInitialHistory),
            ),
          ).called(1);
        },
      );

      blocTest<ChatBloc, BotState>(
        'emits [ChatLoading, ChatError] with user message and error reply on failure',
        setUp: () {
          // Arrange: Stub the use case to return a failure
          when(
            () => mockGetChatReplyUsecase(any()),
          ).thenAnswer((_) async => Left(tFailure));
        },
        build: () => chatBloc,
        seed: () => ChatLoaded(messages: tInitialHistory),
        act: (bloc) => bloc.add(const SendChatMessage(query: tUserQuery)),
        expect:
            () => [
              // 1. Optimistic state: show user's message while loading
              ChatLoading(messages: [...tInitialHistory, tUserMessage]),
              // 2. Final state: show the error message from the bot
              ChatError(
                errorMessage: tFailure.message,
                messages: [...tInitialHistory, tUserMessage, tErrorReply],
              ),
            ],
        verify: (_) {
          // Verify the use case was still called correctly
          verify(
            () => mockGetChatReplyUsecase(
              GetChatReplyParams(query: tUserQuery, history: tInitialHistory),
            ),
          ).called(1);
        },
      );
    });
  });
}
