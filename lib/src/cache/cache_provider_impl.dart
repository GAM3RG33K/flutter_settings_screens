import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cache_provider.dart';

/// A cache access provider class for shared preferences using shared_preferences library.
///
/// This cache provider implementation is used by default, if non is provided explicitly.
class SharePreferenceCache extends CacheProvider {
  late SharedPreferences _preferences;

  @override
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _preferences = await SharedPreferences.getInstance();
  }

  Set get keys => getKeys();

  @override
  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  @override
  double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  @override
  int? getInt(String key) {
    return _preferences.getInt(key);
  }

  @override
  String? getString(String key) {
    return _preferences.getString(key);
  }

  @override
  Future<void> setBool(String key, bool? value, {bool? defaultValue = false}) {
    return _preferences.setBool(key, value ?? defaultValue!);
  }

  @override
  Future<void> setDouble(String key, double? value,
      {double? defaultValue = 0.0}) {
    return _preferences.setDouble(key, value ?? defaultValue!);
  }

  @override
  Future<void> setInt(String key, int? value, {int? defaultValue = 0}) {
    return _preferences.setInt(key, value ?? defaultValue!);
  }

  @override
  Future<void> setString(String key, String? value, {String? defaultValue}) {
    return _preferences.setString(key, value ?? defaultValue!);
  }

  @override
  Future<void> setObject<T>(String key, T value) {
    if (value is int) {
      return _preferences.setInt(key, value);
    }
    if (value is double) {
      return _preferences.setDouble(key, value);
    }
    if (value is bool) {
      return _preferences.setBool(key, value);
    }
    if (value is String) {
      return _preferences.setString(key, value);
    }
    throw Exception('No Implementation Found');
  }

  @override
  bool containsKey(String key) {
    return _preferences.containsKey(key);
  }

  @override
  Set getKeys() {
    return _preferences.getKeys();
  }

  @override
  Future<void> remove(String key) async {
    if (containsKey(key)) {
      await _preferences.remove(key);
    }
  }

  @override
  Future<void> removeAll() async {
    await _preferences.clear();
  }

  @override
  T getValue<T>(String key, T defaultValue) {
    if (defaultValue is int) {
      return _preferences.getInt(key) as T;
    }
    if (defaultValue is double) {
      return _preferences.getDouble(key) as T;
    }
    if (defaultValue is bool) {
      return _preferences.getBool(key) as T;
    }
    if (defaultValue is String) {
      return _preferences.getString(key) as T;
    }
    throw Exception('No Implementation Found');
  }
}
