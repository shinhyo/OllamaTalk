import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_command.freezed.dart';

@freezed
sealed class UICommand with _$UICommand {
  const factory UICommand.showToast({
    required String message,
    @Default(Duration(seconds: 2)) Duration duration,
  }) = ShowToastCommand;

  const factory UICommand.showSnackBar({
    required String message,
    @Default(Duration(seconds: 2)) Duration duration,
    SnackBarAction? action,
  }) = ShowSnackBarCommand;
}

class UICommandController {
  final _controller = StreamController<UICommand>.broadcast();

  Stream<UICommand> get stream => _controller.stream;

  bool get isClosed => _controller.isClosed;

  void showSnackBar({
    required String message,
    required Duration duration,
    SnackBarAction? action,
  }) {
    if (isClosed) return;
    _controller.add(
      ShowSnackBarCommand(
        message: message,
        duration: duration,
        action: action,
      ),
    );
  }

  void showToast({
    required String message,
    required Duration duration,
  }) {
    if (isClosed) return;
    _controller.add(
      ShowToastCommand(message: message, duration: duration),
    );
  }

  Future<void> dispose() async {
    if (isClosed) return;
    await _controller.close();
  }
}
