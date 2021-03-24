import 'package:flutter_settings_screens/flutter_settings_screens.dart';

/// This is an abstract class to provide access of storage/preferences platform
/// from the developer's existing app to this settings screen
///
/// For example:
///  the developer can choose to provide the existing preference platform
///  access by providing the implementation for this class.
///
///  if the developer is using the `shared_preferences` library, then the implementation
///  of one of the methods would look like this:
///  ``` dart
///        // SharedPreferences _preferences = await SharedPreferences.getInstance();
///
///         String getString(String key) {
///           return _preferences.getString(key);
///         }
///
///         Future<void> setBool(String key, bool value) {
///           return _preferences.setBool(key, value);
///         }
///  ```
///
///  and if the developer is using the Hive library or storing preferences/data
///  then the implementation would look like this:
///
///  ```dart
///     //Box _preferences = await Hive.openBox(keyName);
///       String getString(String key) {
///         return _preferences.get(key);
///       }
///
///       Future<void> setBool(String key, bool value) {
///         return _preferences.put(key, value);
///       }
///  ```
///
/// Similarly, if the developer is using any other type of library for this purpose,
/// just providing the implementation using that library will be sufficient for
/// using the settings screen
///
///
/// For more details on how to properly implement this class, Check out the
/// `cache_provider.dart` file in the example code of this library along with
/// the existing [SharePreferenceCache] implementation.
///
abstract class CacheProvider {
  CacheProvider();

  Future<void> init();

  int getInt(String key);

  String getString(String key);

  double getDouble(String key);

  bool getBool(String key);

  Future<void> setInt(String key, int value);

  Future<void> setString(String key, String value);

  Future<void> setDouble(String key, double value);

  Future<void> setBool(String key, bool value);

  bool containsKey(String key);

  Set getKeys();

  Future<void> remove(String key);

  Future<void> removeAll();

  Future<void> setObject<T>(String key, T value);

  T getValue<T>(String key, T defaultValue);
}
