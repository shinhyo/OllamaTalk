import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../i18n/strings.g.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/theme_ext.dart';
import '../../../routing/router.dart';
import '../chat_history_viewmodel.dart';

class ChatRoomListItem extends StatelessWidget {
  final RoomItem item;
  final bool isLast;

  const ChatRoomListItem({
    super.key,
    required this.item,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => ChatScreenRoute.loadHistory(id: item.room.id).push(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(context),
          const SizedBox(height: 4.0),
          _buildMessage(context),
          const SizedBox(height: 8.0),
          _buildBar(context),
          if (isLast) const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        item.room.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.titleSmall?.copyWith(
          color: context.color.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        item.lastMessage?.content ?? '',
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.bodyMedium?.copyWith(
          color: AppColors.grey,
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    final textStyle =
        context.textTheme.labelSmall?.copyWith(color: AppColors.grey);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: Row(
        children: [
          const Icon(
            Icons.watch_later_outlined,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            item.formattedTime,
            style: textStyle,
          ),
          const SizedBox(width: 8),
          if (item.model != null)
            Text(
              '${item.model}',
              style: textStyle?.copyWith(color: AppColors.green),
            ),
          const SizedBox(width: 8),
          const Spacer(),
          PopupMenuButton(
            position: PopupMenuPosition.under,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.delete),
                    const SizedBox(width: 8),
                    Text(t.common.delete),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteConfirmationDialog(
                  context,
                  onConfirm: () {
                    context
                        .read<ChatHistoryViewModel>()
                        .deleteChatRoom(item.room.id);
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context, {
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(t.common.deleteTitle),
          content: Text(t.common.deleteContent),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text(t.common.cancel),
            ),
            TextButton(
              onPressed: () {
                if (onConfirm != null) onConfirm();
                context.pop();
              },
              child: Text(t.common.delete),
            ),
          ],
        );
      },
    );
  }
}
