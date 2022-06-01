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
///         String? getString(String key, {String? defaultValue}) {
///           return _preferences.getString(key) ?? defaultValue;
///         }
///
///         Future<void> setBool(String key, bool? value) async {
///           await _preferences.setBool(key, value);
///         }
///  ```
///
///  and if the developer is using the Hive library or storing preferences/data
///  then the implementation would look like this:
///
///  ```dart
///     //Box _preferences = await Hive.openBox(keyName);
///       String? getString(String key,  {String? defaultValue}) {
///         return _preferences.get(key) ?? defaultValue;
///       }
///
///       Future<void> setBool(String key, bool? value) async {
///         await _preferences.put(key, value);
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

  /// Method to perform initializations regarding the underlying storage systems
  /// ex. Creating instance of the SharedPreferences or Hive boxes
  ///
  /// This method must be called one the cache provider implementation to ensure
  /// smooth operation.
  Future<void> init();

  /// Method to get Int value from the storage, if the retrieved value is null
  /// then [defaultValue] should be used, if provided.
  ///
  ///
  /// Example code(SharedPreferences Implementation):
  /// ///  ```dart
  ///       int? getInt(String key,  {int? defaultValue}) {
  ///         return _preferences.getInt(key) ?? defaultValue;
  ///       }
  ///  ```
  ///
  /// The [defaultValue] is an optional & nullable value, you may choose not to provide it
  /// in which case the null value will be returned as result.
  ///
  /// Output can be represented like this:
  ///   getterOutput -if-absent-> defaultValue -if-absent-> null
  ///
  /// here [getterOutput] is the expected output of the getter method called.
  /// The method must be implementation of one of the definitions from the cache provider
  ///
  int? getInt(String key, {int? defaultValue});

  /// Method to get String value from the storage, if the retrieved value is null
  /// then [defaultValue] should be used, if provided.
  ///
  ///
  /// Example code(SharedPreferences Implementation):
  /// ///  ```dart
  ///       String? getString(String key,  {String? defaultValue}) {
  ///         return _preferences.getString(key) ?? defaultValue;
  ///       }
  ///  ```
  ///
  /// The [defaultValue] is an optional & nullable value, you may choose not to provide it
  /// in which case the null value will be returned as result.
  ///
  /// Output can be represented like this:
  ///   getterOutput -if-absent-> defaultValue -if-absent-> null
  ///
  /// here [getterOutput] is the expected output of the getter method called.
  /// The method must be implementation of one of the definitions from the cache provider
  ///
  String? getString(String key, {String? defaultValue});

  /// Method to get double value from the storage, if the retrieved value is null
  /// then [defaultValue] should be used, if provided.
  ///
  ///
  /// Example code(SharedPreferences Implementation):
  /// ///  ```dart
  ///       double? getDouble(String key,  {double? defaultValue}) {
  ///         return _preferences.getDouble(key) ?? defaultValue;
  ///       }
  ///  ```
  ///
  /// The [defaultValue] is an optional & nullable value, you may choose not to provide it
  /// in which case the null value will be returned as result.
  ///
  /// Output can be represented like this:
  ///   getterOutput -if-absent-> defaultValue -if-absent-> null
  ///
  /// here [getterOutput] is the expected output of the getter method called.
  /// The method must be implementation of one of the definitions from the cache provider
  ///
  double? getDouble(String key, {double? defaultValue});

  /// Method to get boolean value from the storage, if the retrieved value is null
  /// then [defaultValue] should be used, if provided.
  ///
  ///
  /// Example code(SharedPreferences Implementation):
  /// ///  ```dart
  ///       double? getBool(String key,  {bool? defaultValue}) {
  ///         return _preferences.getBool(key) ?? defaultValue;
  ///       }
  ///  ```
  ///
  /// The [defaultValue] is an optional & nullable value, you may choose not to provide it
  /// in which case the null value will be returned as result.
  ///
  /// Output can be represented like this:
  ///   getterOutput -if-absent-> defaultValue -if-absent-> null
  ///
  /// here [getterOutput] is the expected output of the getter method called.
  /// The method must be implementation of one of the definitions from the cache provider
  ///
  bool? getBool(String key, {bool? defaultValue});

  /// Method to set int value to the storage, value can be null according
  /// to the support by underlying storage system.
  ///
  ///
  /// Example code(SharedPreferences Implementation):
  /// ///  ```dart
  ///       Future<void> getInt(String key, int? value) async {
  ///         await _preferences.setInt(key, value);
  ///       }
  ///  ```
  ///
  Future<void> setInt(String key, int? value);

  /// Method to set String value to the storage, value can be null according
  /// to the support by underlying storage system.
  ///
  ///
  /// Example code(SharedPreferences Implementation):
  /// ///  ```dart
  ///       Future<void> setString(String key, String? value) async {
  ///         await _preferences.setString(key, value);
  ///       }
  ///  ```
  ///
  Future<void> setString(String key, String? value);

  /// Method to set Double value to the storage, value can be null according
  /// to the support by underlying storage system.
  ///
  ///
  /// Example code(SharedPreferences Implementation):
  /// ///  ```dart
  ///       Future<void> setDouble(String key, double? value) async {
  ///         await _preferences.setDouble(key, value);
  ///       }
  ///  ```
  ///
  Future<void> setDouble(String key, double? value);

  /// Method to set boolean value to the storage, value can be null according
  /// to the support by underlying storage system.
  ///
  ///
  /// Example code(SharedPreferences Implementation):
  /// ///  ```dart
  ///       Future<void> setBool(String key, bool? value) async {
  ///         await _preferences.setBool(key, value);
  ///       }
  ///  ```
  ///
  Future<void> setBool(String key, bool? value);

  /// This method is used to check if a specific [key] is available/stored
  /// in the underlying storage
  bool containsKey(String key);

  /// This method is used to get a set of available/stored keys
  /// in the underlying storage.
  ///
  /// This method makes easy to iterate over stored keys for various
  /// purposes.
  ///
  /// For example: finding a set of keys from all the available
  /// keys that matches a regular expression
  Set getKeys();

  /// This method is used to remove provided [key] from the underlying storage system.
  ///
  /// For some storage systems, this call can be equivalent to setting null as
  /// value for the given [key]
  ///
  Future<void> remove(String key);

  /// This method is used to remove all the available/stored keys from the
  /// underlying storage system.
  ///
  /// Implementing this method can utilize the [getKeys] method to iterate & remove
  /// or can use interface methods with same purpose provided by the underlying
  /// storage system
  Future<void> removeAll();

  /// Method to set custom object value to the storage, value can be null according
  /// to the support by underlying storage system.
  ///
  /// Example code(SharedPreferences Implementation):
  /// ///  ```dart
  ///       Future<void> setObject<T>(String key, T? value) async {
  ///        if (T is int || value is int) {
  ///          await _preferences?.setInt(key, value as int);
  ///        }
  ///        if (T is double || value is double) {
  ///          await _preferences?.setDouble(key, value as double);
  ///        }
  ///        if (T is bool || value is bool) {
  ///          await _preferences?.setBool(key, value as bool);
  ///        }
  ///        if (T is String || value is String) {
  ///          await _preferences?.setString(key, value as String);
  ///        }
  ///        throw Exception('No Implementation Found');
  ///       }
  ///  ```
  ///
  Future<void> setObject<T>(String key, T? value);

  /// Method to get custom object value from the storage, if the retrieved value is null
  /// then [defaultValue] should be used, if provided.
  ///
  ///
  /// Example code(SharedPreferences Implementation):
  /// ///  ```dart
  ///       T? getValue<T>(String key,  {T? defaultValue}) {
  ///             if (T is int || defaultValue is int) {
  ///               return _preferences?.getInt(key) as T;
  ///             }
  ///             if (T is double || defaultValue is double) {
  ///               return _preferences?.getDouble(key) as T;
  ///             }
  ///             if (T is bool || defaultValue is bool) {
  ///               return _preferences?.getBool(key) as T;
  ///             }
  ///             if (T is String || defaultValue is String) {
  ///               return _preferences?.getString(key) as T;
  ///             }
  ///             throw Exception('No Implementation Found');
  ///       }
  ///  ```
  ///
  /// T - Represents any valid class or primitive types supported by flutter
  ///
  /// The [defaultValue] is an optional & nullable value, you may choose not to provide it
  /// in which case the null value will be returned as result.
  ///
  /// Output can be represented like this:
  ///   getterOutput -if-absent-> defaultValue -if-absent-> null
  ///
  /// here [getterOutput] is the expected output of the getter method called.
  /// The method must be implementation of one of the definitions from the cache provider
  ///
  T? getValue<T>(String key, {T? defaultValue});
}
