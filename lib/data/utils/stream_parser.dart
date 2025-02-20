import 'dart:convert';

import '../../utils/logger.dart';

Stream<T> parseJsonStream<T>(Stream<List<int>> inputStream,
    T Function(Map<String, dynamic>) fromJson,) async* {
  final buffer = StringBuffer();
  const decoder = Utf8Decoder();
  bool isJsonStarted = false;

  await for (final chunk in inputStream) {
    final decodedChunk = decoder.convert(chunk);
    buffer.write(decodedChunk);

    if (!isJsonStarted && buffer.toString().trim().startsWith('{')) {
      isJsonStarted = true;
    }

    if (isJsonStarted && buffer.toString().trim().endsWith('}')) {
      try {
        final jsonMap = jsonDecode(buffer.toString()) as Map<String, dynamic>;
        yield fromJson(jsonMap);
        buffer.clear();
        isJsonStarted = false;
      } catch (e, stackTrace) {
        logError('Error parsing JSON chunk: ${buffer.toString()}', stackTrace);
        continue;
      }
    }
  }
}
