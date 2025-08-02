import 'package:equatable/equatable.dart';

enum ChatRole { user, model }

class ChatMessageEntity extends Equatable {
  final ChatRole role;
  final String text;

  const ChatMessageEntity({required this.role, required this.text});

  @override
  List<Object?> get props => [role, text];
}
