import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/dependencies.dart';
import '../../../i18n/strings.g.dart';
import '../../core/base/base_screen.dart';
import '../../core/themes/theme_ext.dart';
import 'chat_history_viewmodel.dart';
import 'widget/chat_room_header.dart';
import 'widget/chat_room_list.dart';

class ChatHistoryScreen extends BaseScreen<ChatHistoryViewModel> {
  const ChatHistoryScreen({super.key});

  static const label = 'History';

  @override
  ChatHistoryViewModel createViewModel(BuildContext context) {
    return getIt<ChatHistoryViewModel>();
  }

  @override
  Widget buildScaffold(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ChatHistoryViewModel, UiState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.chatRooms.isEmpty) {
            return _buildEmptyHistory(context);
          }

          final chatRooms = state.chatRooms;
          return ListView.separated(
            itemCount: chatRooms.length,
            separatorBuilder: (_, __) => const Divider(thickness: 0.1),
            itemBuilder: (context, index) {
              final item = chatRooms[index];
              return item.map(
                header: (header) =>
                    ChatRoomHeader(date: header.date, index: index),
                room: (room) => ChatRoomListItem(
                  item: room,
                  isLast: index == chatRooms.length - 1,
                ),
              );
            },
          );
        },
        listener: (context, state) {},
      ),
    );
  }

  Widget _buildEmptyHistory(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.forum_outlined, size: 48),
          const SizedBox(height: 10),
          Text(
            t.history.emptyTitle,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
