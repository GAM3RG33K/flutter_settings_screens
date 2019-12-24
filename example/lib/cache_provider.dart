import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A cache access provider class for shared preferences using Hive library
class HiveCache extends CacheProvider {
  Box _preferences;
  final String keyName = 'app_preferences';

  @override
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (!kIsWeb) {
      Directory defaultDirectory = await getApplicationDocumentsDirectory();
      Hive.init(defaultDirectory.path);
    }
    _preferences = await Hive.openBox(keyName);
  }

  get keys => getKeys();

  @override
  bool getBool(String key) {
    return _preferences.get(key);
  }

  @override
  double getDouble(String key) {
    return _preferences.get(key);
  }

  @override
  int getInt(String key) {
    return _preferences.get(key);
  }

  @override
  String getString(String key) {
    return _preferences.get(key);
  }

  @override
  Future<void> setBool(String key, bool value) {
    return _preferences.put(key, value);
  }

  @override
  Future<void> setDouble(String key, double value) {
    return _preferences.put(key, value);
  }

  @override
  Future<void> setInt(String key, int value) {
    return _preferences.put(key, value);
  }

  @override
  Future<void> setString(String key, String value) {
    return _preferences.put(key, value);
  }

  @override
  Future<void> setObject<T>(String key, T value) {
    return _preferences.put(key, value);
  }

  @override
  bool containsKey(String key) {
    return _preferences.containsKey(key);
  }

  @override
  Set<E> getKeys<E>() {
    return _preferences.keys.cast<E>().toSet();
  }

  @override
  Future<void> remove(String key) async {
    if (containsKey(key)) {
      await _preferences.delete(key);
    }
  }

  @override
  Future<void> removeAll() async {
    final keys = getKeys();
    await _preferences.deleteAll(keys);
  }

  @override
  dynamic getValue(String settingsKey) {
    return _preferences.get(settingsKey);
  }

  @override
  T getObject<T>(String key) {
    return _preferences.get(key).cast<T>();
  }
}

/// A cache access provider class for shared preferences using shared_preferences library
class SharePreferenceCache extends CacheProvider {
  SharedPreferences _preferences;

  @override
  Future<void> init() async {
    assert(
        !kIsWeb, 'SharedPreferences Library does not support web apps, yet.');
    WidgetsFlutterBinding.ensureInitialized();
    _preferences = await SharedPreferences.getInstance();
  }

  get keys => getKeys();

  @override
  bool getBool(String key) {
    return _preferences.getBool(key);
  }

  @override
  double getDouble(String key) {
    return _preferences.getDouble(key);
  }

  @override
  int getInt(String key) {
    return _preferences.getInt(key);
  }

  @override
  String getString(String key) {
    return _preferences.getString(key);
  }

  @override
  Future<void> setBool(String key, bool value) {
    return _preferences.setBool(key, value);
  }

  @override
  Future<void> setDouble(String key, double value) {
    return _preferences.setDouble(key, value);
  }

  @override
  Future<void> setInt(String key, int value) {
    return _preferences.setInt(key, value);
  }

  @override
  Future<void> setString(String key, String value) {
    return _preferences.setString(key, value);
  }

  @override
  void setObject<T>(String key, T value) {
    throw Exception('No Implementation Found');
  }

  @override
  bool containsKey(String key) {
    return _preferences.containsKey(key);
  }

  @override
  Set<E> getKeys<E>() {
    return _preferences.getKeys().cast<E>();
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
  dynamic getValue(String settingsKey) {
    return _preferences.get(settingsKey);
  }

  @override
  T getObject<T>(String key) {
    throw Exception('No Implementation Found');
  }
}
