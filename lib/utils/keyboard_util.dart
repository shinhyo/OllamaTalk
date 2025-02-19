import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardUtils {
  KeyboardUtils._();

  static void handleEnterKeyEvent({
    required bool isMobile,
    required KeyEvent event,
    required TextEditingController controller,
    required VoidCallback onSubmit,
  }) {
    if (!isMobile &&
        event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter) {
      if (HardwareKeyboard.instance.isShiftPressed) {
        _insertNewLine(controller);
      } else {
        onSubmit();
      }
    }
  }

  static void _insertNewLine(TextEditingController controller) {
    final text = controller.text;
    final selection = controller.selection;
    final newText = text.replaceRange(selection.start, selection.end, '\n');
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selection.start + 1),
    );
  }
}
