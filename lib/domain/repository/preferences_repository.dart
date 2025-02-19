enum PreferenceKeys<T> {
  apiHost<String>(defaultValue: 'http://localhost:11434'),
  ollamaModel<String>(defaultValue: null),
  chatMode<String>(defaultValue: null),
  prompt<String>(defaultValue: 'You are a helpful assistant.'),
  themeMode<String>(defaultValue: 'dark'),
  ;

  final T? defaultValue;

  const PreferenceKeys({
    required this.defaultValue,
  });

  T? getDefaultValue() => defaultValue;
}

abstract class PreferencesRepository {
  T? get<T>(PreferenceKeys<T> key);

  Future<bool> set<T>(PreferenceKeys<T> key, T value);

  Future<void> clear();

  Stream<T?> watch<T>(PreferenceKeys<T> key);

  void dispose();
}
