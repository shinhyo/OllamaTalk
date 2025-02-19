import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repository/preferences_repository.dart';
import '../../utils/logger.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  final SharedPreferences _prefs;
  final _controller = BehaviorSubject<Map<PreferenceKeys, dynamic>>();

  final Map<PreferenceKeys, dynamic> _cache = {};

  PreferencesRepositoryImpl._(this._prefs) {
    _initializeCache();
  }

  static Future<PreferencesRepositoryImpl> create() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return PreferencesRepositoryImpl._(prefs);
    } catch (e, stackTrace) {
      logError(e, stackTrace);
      rethrow;
    }
  }

  void _initializeCache() {
    for (var key in PreferenceKeys.values) {
      _cache[key] = _prefs.get(key.toString()) ?? key.defaultValue;
    }
  }

  void _notifyListeners(PreferenceKeys key, dynamic value) {
    try {
      if (!_controller.isClosed) {
        _controller.add({key: value});
      }
    } catch (e, stackTrace) {
      logError(e, stackTrace);
    }
  }

  @override
  T? get<T>(PreferenceKeys<T> key) {
    try {
      if (_cache.containsKey(key)) {
        final value = _cache[key];
        return value as T?;
      }

      final value = _prefs.get(key.toString());
      _cache[key] = value;
      return value as T?;
    } catch (e, stackTrace) {
      logError(e, stackTrace);
      return null;
    }
  }

  @override
  Future<bool> set<T>(PreferenceKeys<T> key, T value) async {
    try {
      bool result = false;
      switch (value) {
        case String():
          result = await _prefs.setString(key.toString(), value);
        case int():
          result = await _prefs.setInt(key.toString(), value);
        case bool():
          result = await _prefs.setBool(key.toString(), value);
        case double():
          result = await _prefs.setDouble(key.toString(), value);
        default:
          throw ArgumentError('${value.runtimeType}');
      }
      logDebug('set $key = $value   $result');
      if (result) {
        _cache[key] = value;
        _notifyListeners(key, value);
      }

      return result;
    } catch (e, stackTrace) {
      logError(e, stackTrace);
      return false;
    }
  }

  @override
  Stream<T?> watch<T>(PreferenceKeys<T> key) async* {
    try {
      final initialValue = get<T>(key);
      yield initialValue;

      yield* _controller.stream
          .where((event) => event.containsKey(key))
          .map((event) => event[key] as T?)
          .distinct()
          // .doOnData((value) => logDebug('watch stream $key = $value'))
          .onErrorReturn(null);
    } catch (e, stackTrace) {
      logError(e, stackTrace);
      yield null;
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _prefs.clear();
      _cache.clear();
    } catch (e, stackTrace) {
      logError(e, stackTrace);
    }
  }

  @override
  void dispose() {
    try {
      _cache.clear();
      _controller.close();
    } catch (e, stackTrace) {
      logError(e, stackTrace);
    }
  }
}
