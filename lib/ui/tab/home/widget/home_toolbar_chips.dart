import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../i18n/strings.g.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/icons.dart';
import '../../../core/themes/theme_ext.dart';
import '../../../core/widget/chip_menu_anchor.dart';
import '../../../core/widget/dialog.dart';

class ChatCommonToolbar extends StatelessWidget {
  final bool isMini;
  final bool isLoading;
  final List<String> models;
  final int modelIdx;
  final ValueChanged<String> onModel;
  final List<String> chatModes;
  final int chatModeIdx;
  final ValueChanged<String> onChatMode;
  final String prompt;
  final ValueChanged<String> onPrompt;

  const ChatCommonToolbar({
    super.key,
    this.isMini = false,
    required this.isLoading,
    required this.models,
    required this.modelIdx,
    required this.onModel,
    required this.chatModes,
    required this.chatModeIdx,
    required this.onChatMode,
    required this.prompt,
    required this.onPrompt,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingChip(context);
    }
    return Wrap(
      spacing: 6.0,
      runSpacing: 8.0,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildModelChip(context),
        _buildModeChip(context),
        _buildPromptChip(context),
      ],
    );
  }

  Widget _buildModelChip(BuildContext context) {
    return ChipMenuAnchor(
      isMini: isMini,
      icon: context.icon(AppIcons.headSnowflake, color: AppColors.green),
      list: models,
      index: modelIdx,
      onSelected: (value) => value != null ? onModel(value) : null,
      tooltip: 'Model',
    );
  }

  Widget _buildModeChip(BuildContext context) {
    return ChipMenuAnchor(
      isMini: isMini,
      icon: context.icon(AppIcons.tune, color: AppColors.red),
      list: chatModes,
      index: chatModeIdx,
      onSelected: (value) => value != null ? onChatMode(value) : null,
      tooltip: 'Chat Mode',
    );
  }

  Widget _buildPromptChip(BuildContext context) {
    final icon = context.icon(AppIcons.keyboard, color: AppColors.purple);
    return InkWell(
      onTap: () => _showPromptDialog(context),
      child: isMini
          ? _buildMiniPromptChip(context, icon)
          : _buildFullPromptChip(context, icon),
    );
  }

  Widget _buildMiniPromptChip(BuildContext context, SvgPicture icon) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: icon,
      ),
    );
  }

  Widget _buildFullPromptChip(BuildContext context, SvgPicture icon) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: context.color.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 8),
          Text(prompt),
        ],
      ),
    );
  }

  Chip _buildLoadingChip(BuildContext context) {
    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Text(t.home.loading, style: context.textTheme.bodySmall)],
      ),
    );
  }

  void _showPromptDialog(BuildContext context) {
    final controller = TextEditingController(text: prompt);
    showAppDialog(
      context: context,
      title: t.home.promptTitle,
      content: TextField(
        controller: controller,
        maxLines: 5,
        minLines: 3,
        decoration: InputDecoration(
          hintText: t.home.promptHint,
          helper: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SelectableText(t.home.promptHelper),
          ),
          border: const OutlineInputBorder(),
        ),
      ),
      onConfirm: () {
        onPrompt(controller.text.trim());
      },
    );
  }
}
