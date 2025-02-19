import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import '../../../domain/repository/preferences_repository.dart';

final Dio dio = Dio(
  BaseOptions(),
)..interceptors.addAll([
    if (kDebugMode)
      TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
        ),
      ),
  ]);

class ApiClient {
  static Dio createDio(PreferencesRepository prefs) {
    final String baseUrl = prefs.get<String>(PreferenceKeys.apiHost)!;
    final baseOptions = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
      },
      validateStatus: (status) => true,
    );
    return Dio(baseOptions)
      ..interceptors.addAll([
        if (kDebugMode)
          TalkerDioLogger(
            settings: const TalkerDioLoggerSettings(
              printRequestHeaders: true,
              printResponseHeaders: true,
            ),
          ),
      ]);
  }
}
