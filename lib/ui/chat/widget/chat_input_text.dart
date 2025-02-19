import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../i18n/strings.g.dart';
import '../../../utils/keyboard_util.dart';
import '../../../utils/platform_util.dart';
import '../../core/themes/theme_ext.dart';
import '../chat_viewmodel.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ChatViewModel>();
    final isMobile = PlatformUtils.isMobile;

    return BlocBuilder<ChatViewModel, ChatUiState>(
      buildWhen: (previous, current) {
        return previous.isGeneratingChat != current.isGeneratingChat;
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          color: context.color.surface,
          child: _buildMessageInput(viewModel, state, isMobile),
        );
      },
    );
  }

  Widget _buildMessageInput(
    ChatViewModel viewModel,
    ChatUiState state,
    bool isMobile,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (KeyEvent event) {
              KeyboardUtils.handleEnterKeyEvent(
                isMobile: isMobile,
                event: event,
                controller: viewModel.messageController,
                onSubmit: () => viewModel.sendMessage(),
              );
            },
            child: TextField(
              controller: viewModel.messageController,
              focusNode: viewModel.messageFocusNode,
              maxLines: null,
              minLines: 1,
              textInputAction:
                  isMobile ? TextInputAction.newline : TextInputAction.none,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: t.chat.hintText,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ),
        ),
        _buildSendButton(viewModel, state),
      ],
    );
  }

  Widget _buildSendButton(ChatViewModel viewModel, ChatUiState state) {
    return IconButton(
      icon: state.isGeneratingChat
          ? const Icon(Icons.stop)
          : const Icon(Icons.send),
      onPressed:
          state.isGeneratingChat ? viewModel.cancelChat : viewModel.sendMessage,
    );
  }
}
