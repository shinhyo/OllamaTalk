import 'dart:io';

import 'package:flutter/foundation.dart';

class PlatformUtils {
  PlatformUtils._();

  static bool get isDesktop =>
      !kIsWeb &&
      (Platform.isWindows ||
          Platform.isLinux ||
          Platform.isMacOS ||
          Platform.isFuchsia);

  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  static bool get isWeb => kIsWeb;
}
