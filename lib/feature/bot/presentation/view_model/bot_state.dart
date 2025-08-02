import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/feature/bot/domain/entity/bot_entity.dart';

abstract class BotState extends Equatable {
  final List<ChatMessageEntity> messages;

  const BotState({required this.messages});

  @override
  List<Object> get props => [messages];
}

class ChatInitial extends BotState {
  ChatInitial()
    : super(
        messages: [
          // Pre-populate with the bot's static welcome message
          const ChatMessageEntity(
            role: ChatRole.model,
            text:
                "Hey Hiker! I'm TrailMate, your guide to all things hiking. How can I help you navigate your next adventure today?",
          ),
        ],
      );
}

class ChatLoading extends BotState {
  const ChatLoading({required super.messages});
}

class ChatLoaded extends BotState {
  const ChatLoaded({required super.messages});
}

class ChatError extends BotState {
  final String errorMessage;

  const ChatError({required this.errorMessage, required super.messages});

  @override
  List<Object> get props => [errorMessage, messages];
}
