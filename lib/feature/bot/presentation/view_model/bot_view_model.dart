import 'package:bloc/bloc.dart';
import 'package:hamro_grocery_mobile/feature/bot/domain/entity/bot_entity.dart';
import 'package:hamro_grocery_mobile/feature/bot/domain/usecase/get_chat_reply_usecase.dart';
import 'package:hamro_grocery_mobile/feature/bot/presentation/view_model/bot_event.dart';
import 'package:hamro_grocery_mobile/feature/bot/presentation/view_model/bot_state.dart';

class ChatBloc extends Bloc<BotEvent, BotState> {
  final GetChatReplyUsecase getChatReplyUsecase;

  ChatBloc({required this.getChatReplyUsecase}) : super(ChatInitial()) {
    on<InitializeChat>(_onInitializeChat);
    on<SendChatMessage>(_onSendChatMessage);
  }

  /// Handles the initial setup of the chat.
  void _onInitializeChat(InitializeChat event, Emitter<BotState> emit) {
    // This welcome message is from your `knowledge_base.js`.
    final welcomeMessage = ChatMessageEntity(
      role: ChatRole.model,
      text:
          "Hello! I'm GrocerBot, your friendly shopping assistant. How can I help you today?",
    );
    emit(ChatLoaded(messages: [welcomeMessage]));
  }

  /// Handles sending a message and receiving a reply.
  Future<void> _onSendChatMessage(
    SendChatMessage event,
    Emitter<BotState> emit,
  ) async {
    final userMessage = ChatMessageEntity(
      role: ChatRole.user,
      text: event.query,
    );

    final currentHistory = List<ChatMessageEntity>.from(state.messages);

    emit(ChatLoading(messages: [...currentHistory, userMessage]));

    // We pass the *original* history, excluding the bot's initial welcome message
    // if we don't want it to affect the context of every single query.
    // For simplicity here, we'll pass the full history.
    final result = await getChatReplyUsecase(
      GetChatReplyParams(query: event.query, history: currentHistory),
    );

    result.fold(
      (failure) {
        final errorReply = ChatMessageEntity(
          role: ChatRole.model,
          text: "Oops! Something went wrong. ${failure.message}",
        );
        emit(
          ChatError(
            errorMessage: failure.message,
            messages: [...state.messages, errorReply],
          ),
        );
      },
      (botReplyEntity) {
        emit(ChatLoaded(messages: [...state.messages, botReplyEntity]));
      },
    );
  }
}
