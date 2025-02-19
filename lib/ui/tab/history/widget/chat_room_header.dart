import 'package:flutter/material.dart';

import '../../../core/themes/theme_ext.dart';

class ChatRoomHeader extends StatelessWidget {
  final String date;
  final int index;

  const ChatRoomHeader({
    super.key,
    required this.date,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: index == 0
          ? const EdgeInsets.fromLTRB(16, 32, 16, 16)
          : const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      width: double.infinity,
      child: Text(
        date,
        style: context.textTheme.headlineSmall?.copyWith(
          color: Colors.grey,
        ),
      ),
    );
  }
}
