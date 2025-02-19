import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../config/dependencies.dart';
import '../../i18n/strings.g.dart';
import '../core/base/base_screen.dart';
import '../core/themes/theme_ext.dart';
import '../core/widget/dialog.dart';
import '../core/widget/dragging_appbar.dart';
import '../core/widget/overay_boundary.dart';
import '../routing/router.dart';
import 'chat_viewmodel.dart';
import 'widget/chat_input_text.dart';
import 'widget/chat_list.dart';
import 'widget/chat_toolbar.dart';

class ChatScreen extends BaseScreen<ChatViewModel> {
  final ChatScreenParams params;
  static const label = 'Home';

  const ChatScreen({
    required this.params,
    super.key,
  });

  @override
  ChatViewModel createViewModel(BuildContext context) {
    return getIt<ChatViewModel>()..init(params);
  }

  @override
  Widget buildScaffold(BuildContext context) {
    return BlocListener<ChatViewModel, ChatUiState>(
      listenWhen: (previous, current) => current.navigateBack,
      listener: (context, state) {
        if (state.navigateBack) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: DraggingAppBar(
          title: BlocSelector<ChatViewModel, ChatUiState, String>(
            selector: (state) => state.chatRoom?.name ?? '',
            builder: (context, state) {
              return Text(
                state,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: context.textTheme.titleMedium,
              );
            },
          ),
          actions: _buildActions(),
        ),
        body: const OverlayBoundary(
          child: Column(
            children: [
              Expanded(child: ChatList()),
              ChatToolbar(),
              ChatInputField(),
            ],
          ),
        ),
      ),
    );
  }

  List<Builder> _buildActions() {
    return [
      Builder(
        builder: (innerContext) {
          return PopupMenuButton(
            position: PopupMenuPosition.under,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'delete') {
                showAppDialog(
                  context: innerContext,
                  title: t.common.deleteTitle,
                  content: Text(t.common.deleteContent),
                  confirmText: t.common.delete,
                  onConfirm: () {
                    innerContext.read<ChatViewModel>().deleteChatRoom();
                  },
                );
              }
            },
          );
        },
      ),
    ];
  }
}
