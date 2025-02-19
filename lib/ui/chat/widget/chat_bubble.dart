import 'package:flutter/material.dart';
import 'package:markdown_widget/config/all.dart';
import 'package:markdown_widget/widget/all.dart';

import '../../core/themes/colors.dart';
import '../../core/themes/icons.dart';
import '../../core/themes/theme_ext.dart';
import '../chat_viewmodel.dart';

class ChatBubble extends StatelessWidget {
  final bool isGeneratingChat;
  final bool isUser;
  final bool isLast;
  final Message message;
  final VoidCallback onTabHeader;

  String get modelName => message.when(
        ai: (model, content, createdAt, updatedAt) => model,
        user: (content, createdAt, updatedAt) => '',
      );

  const ChatBubble({
    super.key,
    required this.message,
    required this.isGeneratingChat,
    required this.isLast,
    required this.onTabHeader,
  }) : isUser = message is UserMessage;

  static final _userMessageDecoration = BoxDecoration(
    color: const Color(0xFF2196F3),
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(5),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        spreadRadius: 1,
        blurRadius: 3,
        offset: const Offset(0, 1),
      ),
    ],
  );

  static const _aiMessageDecoration = BoxDecoration();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        // 여백 추가
        child: Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildMessageContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isUser)
            CircleAvatar(
              radius: 12,
              backgroundColor: AppColors.grey,
              child: context.icon(
                AppIcons.robot,
                size: 18,
                color: context.color.surface,
              ),
            ),
          const SizedBox(width: 8),
          if (!isUser)
            Text(
              modelName,
              style: context.textTheme.labelLarge,
            ),
          if (!isUser && isGeneratingChat && isLast)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.textTheme.bodySmall?.color ?? Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    final content = message.content;
    return Container(
      constraints: const BoxConstraints(),
      padding: isUser
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
          : const EdgeInsets.symmetric(vertical: 12),
      decoration: isUser ? _userMessageDecoration : _aiMessageDecoration,
      child: isUser
          ? SelectableText(
              content,
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                height: 1.4,
              ),
            )
          : MarkdownBlock(
              data: content,
              config: context.isDarkMode
                  ? MarkdownConfig.darkConfig
                  : MarkdownConfig.defaultConfig,
            ),
    );
  }
}
