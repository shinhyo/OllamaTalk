import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../i18n/strings.g.dart';
import '../../../../utils/keyboard_util.dart';
import '../../../../utils/platform_util.dart';
import '../../../core/themes/theme_ext.dart';
import '../home_viewmodel.dart';

class HomeInputField extends StatefulWidget {
  const HomeInputField({super.key});

  @override
  State<HomeInputField> createState() => _HomeInputFieldState();
}

class _HomeInputFieldState extends State<HomeInputField> {
  static const double _borderRadius = 12.0;
  static const EdgeInsets _contentPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets _suffixPadding = EdgeInsets.only(right: 8.0);

  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<HomeViewModel>();

    final isMobile = PlatformUtils.isMobile;

    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (KeyEvent event) {
        final TextEditingController controller = viewModel.messageController;
        KeyboardUtils.handleEnterKeyEvent(
          isMobile: isMobile,
          event: event,
          controller: controller,
          onSubmit: () => viewModel.handleSubmitted(),
        );
      },
      child: VisibilityDetector(
        key: const Key('text_field_visibility'),
        onVisibilityChanged: (info) {
          if (info.visibleFraction == 0) {
            // invisible
            _focusNode.unfocus();
          }
        },
        child: TextField(
          focusNode: _focusNode,
          controller: viewModel.messageController,
          enableInteractiveSelection: true,
          minLines: 2,
          maxLines: 8,
          decoration: InputDecoration(
            hintText: t.home.ask,
            hintStyle: context.textTheme.bodyMedium,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
            ),
            contentPadding: _contentPadding,
            suffixIcon: Padding(
              padding: _suffixPadding,
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  viewModel.handleSubmitted();
                },
              ),
            ),
          ),
          textInputAction:
              isMobile ? TextInputAction.newline : TextInputAction.none,
          keyboardType: TextInputType.multiline,
        ),
      ),
    );
  }

  void keyDownEventLogic({
    required bool isMobile,
    required KeyEvent event,
    required final TextEditingController controller,
    required VoidCallback summit,
  }) {
    if (!isMobile &&
        event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter) {
      if (HardwareKeyboard.instance.isShiftPressed) {
        final text = controller.text;
        final selection = controller.selection;
        final newText = text.replaceRange(selection.start, selection.end, '\n');
        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: selection.start + 1),
        );
      } else {
        summit();
      }
    }
  }
}
