import 'package:equatable/equatable.dart';

abstract class BotEvent extends Equatable {
  const BotEvent();

  @override
  List<Object> get props => [];
}

/// Event to initialize the chat and show the bot's welcome message.
class InitializeChat extends BotEvent {}

/// Event to send a user's message to the bot.
class SendChatMessage extends BotEvent {
  final String query;

  const SendChatMessage({required this.query});

  @override
  List<Object> get props => [query];
}
