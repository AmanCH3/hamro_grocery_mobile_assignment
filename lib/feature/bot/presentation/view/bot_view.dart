import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/feature/bot/domain/entity/bot_entity.dart';
import 'package:hamro_grocery_mobile/feature/bot/presentation/view_model/bot_event.dart';
import 'package:hamro_grocery_mobile/feature/bot/presentation/view_model/bot_state.dart';
import 'package:hamro_grocery_mobile/feature/bot/presentation/view_model/bot_view_model.dart';

class BotView extends StatelessWidget {
  const BotView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatView();
  }
}

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Dispatch the event to show the bot's welcome message on screen load.
    context.read<ChatBloc>().add(InitializeChat());
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatBloc>().add(SendChatMessage(query: text));
      _textController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  // Helper to send a message from a suggestion chip.
  void _sendSuggestedMessage(String message) {
    _textController.text = message;
    _sendMessage();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Updated AppBar to match the "FreshCart" persona
        title: const Text('GrocerBot Assistant'),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, BotState>(
              listener: (context, state) {
                // Scroll to bottom whenever state changes and there's new content
                if (state is ChatLoading ||
                    state is ChatLoaded ||
                    state is ChatError) {
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                if (state is ChatInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.messages.isEmpty) {
                  // This view is now a fallback, the main view starts with the welcome message
                  return _buildWelcomeSuggestions();
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  // Add one extra item for the loading indicator if needed
                  itemCount:
                      state is ChatLoading
                          ? state.messages.length + 1
                          : state.messages.length,
                  itemBuilder: (context, index) {
                    // Show a typing indicator at the end if the bot is "thinking"
                    if (state is ChatLoading &&
                        index == state.messages.length) {
                      return const _TypingIndicator();
                    }
                    final message = state.messages[index];
                    return ChatMessageBubble(message: message);
                  },
                );
              },
            ),
          ),
          _buildTextComposer(),
        ],
      ),
    );
  }

  // A new widget to show helpful suggestions to the user.
  Widget _buildWelcomeSuggestions() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 60,
            color: Colors.green.shade700,
          ),
          const SizedBox(height: 16),
          const Text(
            "Welcome to FreshCart!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Here are a few things you can ask me:",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            children: [
              _SuggestionChip(
                label: 'How to track an order?',
                onTap: () => _sendSuggestedMessage('How can I track my order?'),
              ),
              _SuggestionChip(
                label: 'What are grocery points?',
                onTap: () => _sendSuggestedMessage('What are grocery points?'),
              ),
              _SuggestionChip(
                label: 'How do I cancel an order?',
                onTap: () => _sendSuggestedMessage('How do I cancel an order?'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  // Updated hint text
                  hintText: 'Ask about products, orders...',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendMessage,
              color: Colors.white,
              style: IconButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessageBubble extends StatelessWidget {
  final ChatMessageEntity message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUserMessage = message.role == ChatRole.user;
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        decoration: BoxDecoration(
          // Updated color scheme for messages
          color: isUserMessage ? Colors.green.shade700 : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft:
                isUserMessage
                    ? const Radius.circular(18)
                    : const Radius.circular(4),
            bottomRight:
                isUserMessage
                    ? const Radius.circular(4)
                    : const Radius.circular(18),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUserMessage ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

// Optional: A reusable suggestion chip widget
class _SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SuggestionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: Colors.green.shade50,
      labelStyle: TextStyle(color: Colors.green.shade800),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.green.shade200),
      ),
    );
  }
}

// Optional: A simple typing indicator for better UX
class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: const SizedBox(
          width: 40,
          height: 20,
          // A simple dot animation can be added here
          child: Text(
            "...",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
