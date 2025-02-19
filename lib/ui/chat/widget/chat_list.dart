import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../chat_viewmodel.dart';
import 'chat_bubble.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ChatViewModel, ChatUiState,
        ({List<Message> messages, bool isGeneratingChat})>(
      selector: (ChatUiState state) =>
          (messages: state.messages, isGeneratingChat: state.isGeneratingChat),
      builder: (context, selectedState) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          reverse: true,
          itemCount: selectedState.messages.length,
          itemBuilder: (context, index) {
            final Message message = selectedState.messages[index];
            return ChatBubble(
              message: message,
              isGeneratingChat: selectedState.isGeneratingChat,
              isLast: index == 0,
              onTabHeader: () {},
            );
          },
        );
      },
    );
  }
}
