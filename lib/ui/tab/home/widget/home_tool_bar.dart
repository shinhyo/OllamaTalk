import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../i18n/strings.g.dart';
import '../../../root/widget/root_tab.dart';
import '../home_viewmodel.dart';
import 'home_toolbar_chips.dart';

class ChipToolBar extends StatelessWidget {
  const ChipToolBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: BlocBuilder<HomeViewModel, UiState>(
        builder: (context, state) {
          if (state.uiError == const UiError.initDataLoadFailed()) {
            return _buildConnectionFailed(context);
          }

          final viewModel = context.read<HomeViewModel>();

          final toolbarState = state.toolbar;
          return ChatCommonToolbar(
            isLoading: toolbarState.isLoading,
            models: toolbarState.models,
            modelIdx: toolbarState.modelIdx,
            onModel: (value) {
              viewModel.updateSelectedModel(value);
            },
            chatModes: toolbarState.chatModes,
            chatModeIdx: toolbarState.chatModeIdx,
            onChatMode: (value) {
              viewModel.updateChatMode(value);
            },
            prompt: toolbarState.prompt ?? '',
            onPrompt: (value) {
              viewModel.updatePrompt(value);
            },
          );
        },
      ),
    );
  }

  ActionChip _buildConnectionFailed(BuildContext context) {
    return ActionChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              t.home.unavailable,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              softWrap: true,
            ),
          ),
        ],
      ),
      onPressed: () {
        context.go(RootTab.setting.path);
      },
    );
  }
}
