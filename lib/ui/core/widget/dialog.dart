import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> showAppDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  VoidCallback? onConfirm,
  String? confirmText,
  bool dismissOnConfirm = true,
  String? cancelText,
}) {
  final localizations = MaterialLocalizations.of(context);
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 550,
          child: content,
        ),
        actions: onConfirm == null
            ? []
            : [
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(cancelText ?? localizations.cancelButtonLabel),
                ),
                TextButton(
                  onPressed: () {
                    onConfirm();
                    if (dismissOnConfirm) context.pop();
                  },
                  child: Text(confirmText ?? localizations.okButtonLabel),
                ),
              ],
      );
    },
  );
}
