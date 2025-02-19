import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class DraggingWidget extends StatelessWidget {
  final Widget child;

  const DraggingWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (details) {
        windowManager.startDragging();
      },
      child: child,
    );
  }
}
