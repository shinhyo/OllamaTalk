import 'dart:convert';

import 'package:talker_flutter/talker_flutter.dart';

import '../config/dependencies.dart';

enum LogTag { error, warning, info, debug, critical, verbose }

class Logger {
  static final Logger _instance = Logger._internal();

  final Talker _talker;

  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

  Logger._internal()
      : _talker = Talker(
            settings: TalkerSettings(
          useConsoleLogs: true,
          enabled: true,
        ));

  factory Logger() => _instance;

  void log(dynamic message, LogTag tag, [StackTrace? stackTrace]) {
    final String formattedMessage = _formatMessage(message);
    final logFunction = _getLogFunction(tag, stackTrace);
    logFunction(formattedMessage);
  }

  String _formatMessage(dynamic message) {
    if (message is String) {
      return message;
    }
    return message is Map || message is List
        ? _encoder.convert(message)
        : message.toString();
  }

  void Function(String) _getLogFunction(LogTag tag, [StackTrace? stackTrace]) {
    switch (tag) {
      case LogTag.error:
        return (String msg) => _talker.error(msg, null, stackTrace);
      case LogTag.warning:
        return _talker.warning;
      case LogTag.info:
        return _talker.info;
      case LogTag.debug:
        return _talker.debug;
      case LogTag.critical:
        return _talker.critical;
      case LogTag.verbose:
        return _talker.verbose;
    }
  }

  Talker get talker => _talker;
}

void logError(dynamic message, [StackTrace? stackTrace]) =>
    getIt<Logger>().log(message, LogTag.error, stackTrace);

void logWarning(dynamic message) =>
    getIt<Logger>().log(message, LogTag.warning);

void logInfo(dynamic message) => getIt<Logger>().log(message, LogTag.info);

void logDebug(dynamic message) => getIt<Logger>().log(message, LogTag.debug);

void logCritical(dynamic message) =>
    getIt<Logger>().log(message, LogTag.critical);

void logVerbose(dynamic message) =>
    getIt<Logger>().log(message, LogTag.verbose);
