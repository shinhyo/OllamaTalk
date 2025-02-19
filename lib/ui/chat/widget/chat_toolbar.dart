import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/themes/theme_ext.dart';
import '../../tab/home/widget/home_toolbar_chips.dart';
import '../chat_viewmodel.dart';

class ChatToolbar extends StatelessWidget {
  const ChatToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatViewModel, ChatUiState>(
      builder: (context, state) {
        if (state.uiError != null) {
          return const SizedBox.shrink();
        }
        final viewModel = context.read<ChatViewModel>();
        final optionState = state.option;

        final modelList = optionState.modelList;
        final chatModeList = optionState.chatModeList;

        final indexSelectModel = optionState.indexSelectModel;
        final indexSelectChatMode = optionState.indexSelectChatMode;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: context.color.surface,
          width: double.infinity,
          child: ChatCommonToolbar(
            isMini: true,
            isLoading: state.isInitLoading,
            models: modelList,
            modelIdx: indexSelectModel,
            onModel: (value) {
              viewModel.updateSelectedModel(value);
            },
            chatModes: chatModeList,
            chatModeIdx: indexSelectChatMode,
            onChatMode: (value) {
              viewModel.updateChatMode(value);
            },
            prompt: optionState.prompt,
            onPrompt: (value) {
              viewModel.updatePrompt(value);
            },
          ),
        );
      },
    );
  }
}
