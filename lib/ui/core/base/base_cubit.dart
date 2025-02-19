import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/dependencies.dart';
import 'base_command.dart';

abstract class BaseCubit<State> extends Cubit<State> {
  @protected
  final UICommandController commandController;

  BaseCubit(super.state, {UICommandController? commandController})
      : commandController = commandController ?? getIt<UICommandController>();

  void showToast(
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    if (commandController.isClosed) return;
    commandController.showToast(
      message: message,
      duration: duration,
    );
  }

  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
  }) {
    if (commandController.isClosed) return;
    commandController.showSnackBar(
      message: message,
      duration: duration,
      action: action,
    );
  }
}
