enum BuildType { dev, preview, prod }

class BuildConfig {
  static const mode = String.fromEnvironment(
    'BUILD_MODE',
    defaultValue: 'dev',
  );

  static bool get isDev => mode == 'dev';

  static bool get isPreview => mode == 'preview';

  static bool get isProd => mode == 'prod';

  static BuildType get buildType {
    switch (mode) {
      case 'prod':
        return BuildType.prod;
      case 'preview':
        return BuildType.preview;
      default:
        return BuildType.dev;
    }
  }
}
