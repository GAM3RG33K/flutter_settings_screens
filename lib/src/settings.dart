import 'package:flutter/material.dart';

import 'cache/cache.dart';

/// This function type is used for rebuilding any given child widgets
///
/// All Settings Tile are given a [ValueChangeObserver] with a unique settings key.
///
/// When the value associated with a settings key changes, [ValueChangeObserver]
/// triggers a [InternalWidgetBuilder] function call.
typedef InternalWidgetBuilder<T> = Widget Function(
    BuildContext, T, ValueChanged<T>);

/// This function type is used for building a widget based on the value given to it.
/// It is an alternate version of [WidgetBuilder].
typedef ItemBuilder<T> = Widget Function(T);

/// This function type is used for triggering the callback when value
/// associated with a settings key changes.
typedef OnChanged<T> = void Function(T);

/// This function type is used for verifying that the dialog/modal
/// widget is to be closed or not.
///
/// if true, the widget will be closed
typedef OnConfirmedCallback = bool Function();

/// This class behaves as a bridge between the settings screen widgets and the
/// underlying storage mechanism.
///
/// To access the storage mechanism an instance of the [CacheProvider] implementation
/// is required.
///
/// Any Flutter App using this library must call `Settings.init(cacheProvider)`
/// before showing the settings screen.
///
///
class Settings {
  /// Private constructor
  Settings._internal();

  /// Private instance of this class to keep it singleton
  static final Settings _instance = Settings._internal();

  /// Public factory method to provide the
  factory Settings() {
    assert(
        _cacheProvider != null,
        'Must call Settings.init(cacheProvider)'
        ' before using settings!');
    return _instance;
  }

  /// Private instance of [CacheProvider] which will allow access to the
  /// underlying cache mechanism, which can be any of [SharedPreference],[Hive]
  /// or any other cache provider of choice
  static CacheProvider _cacheProvider;

  /// This method will check and ensure that [_cacheProvider]
  /// value is set properly.
  static void ensureCacheProvider() {
    assert(
        isInitialized,
        'Must call Settings.init(cacheProvider)'
        ' before using settings!');
  }

  /// A getter to know if the settings are already initialized or not
  static bool get isInitialized => _cacheProvider != null;

  /// This method is used for initializing the [_cacheProvider]
  /// instance.
  ///
  /// This method must be called before the Settings screen is displayed.
  ///
  /// Cache provider is optional, default cache provider uses the
  /// shared preferences based cache provider implementation.
  static Future<void> init({CacheProvider cacheProvider}) async {
    cacheProvider ??= SharePreferenceCache();

    _cacheProvider = cacheProvider;
    await _cacheProvider.init();
  }

  /// method to check if the cache provider contains given [key] or not.
  static bool containsKey(String key) {
    ensureCacheProvider();
    assert(key != null);
    return _cacheProvider.containsKey(key);
  }

  /// method to get a value using the [cacheProvider] for given [key]
  ///
  /// If there's no value found associated with the [key] then the [defaultValue]
  /// is returned.
  static T getValue<T>(String key, T defaultValue) {
    ensureCacheProvider();
    assert(key != null);
    if (_cacheProvider.containsKey(key)) {
      return _cacheProvider.getValue<T>(key, defaultValue);
    }
    return defaultValue;
  }

  /// method to set [value] using the [cacheProvider] for given [key]
  static Future<void> setValue<T>(String key, T value) async {
    ensureCacheProvider();
    if (value == null) {
      return _cacheProvider.remove(key);
    }
    await _cacheProvider.setObject<T>(key, value);
  }

  /// method to clear all the cached data using the [cacheProvider]
  static void clearCache() {
    ensureCacheProvider();
    _cacheProvider.removeAll();
  }
}

/// This class is a customized version of [ValueNotifier]
/// which Takes a [key] and [value].
///
/// Value - Setting value which is associated to the [key]
class ValueChangeNotifier<T> extends ValueNotifier<T> {
  /// A String which represents a setting (assumed to be unique)
  final String key;

  ValueChangeNotifier(this.key, value) : super(value);

  @override
  set value(T newValue) {
    Settings.setValue<T>(key, newValue);
    super.value = newValue;
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  @override
  String toString() {
    return '\n{VCN: \n\tkey: $key  \n\tvalue: $value\n}';
  }
}

/// This map is used for keeping the track of the notifier(s) associated with
/// a Settings key
///
/// If a settings key is already added in the map, the new notifier
/// is added to the list of notifiers
Map<String, List<ValueChangeNotifier>> _notifiers =
    <String, List<ValueChangeNotifier>>{};

/// A Stateful widget which Takes in a [cacheKey], a [defaultValue]
/// and a [builder]
///
/// This widget rebuilds whenever there's a change in value associated with the
/// [cacheKey]
class ValueChangeObserver<T> extends StatefulWidget {
  final String cacheKey;
  final T defaultValue;
  final InternalWidgetBuilder<T> builder;

  const ValueChangeObserver({
    @required this.cacheKey,
    @required this.defaultValue,
    @required this.builder,
  });

  @override
  _ValueChangeObserverState<T> createState() => _ValueChangeObserverState<T>();
}

class _ValueChangeObserverState<T> extends State<ValueChangeObserver<T>> {
  T value;

  String get cacheKey => widget.cacheKey;

  T get defaultValue => widget.defaultValue;

  ValueChangeNotifier<T> notifier;

  @override
  void initState() {
    //if [cacheKey] is not found, add new cache in the [cacheProvider] with [defaultValue]
    if (!Settings.containsKey(cacheKey)) {
      Settings.setValue<T>(cacheKey, defaultValue);
    }

    // get cache value from the [cacheProvider]
    value = Settings.getValue<T>(cacheKey, defaultValue);

    // assign a notifier
    notifier = ValueChangeNotifier<T>(cacheKey, value);

    // add notifier to [_notifiers] map
    if (!_notifiers.containsKey(cacheKey)) {
      _notifiers[cacheKey] = List<ValueChangeNotifier<T>>.empty(growable: true);
    }
    _notifiers[cacheKey].add(notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: notifier,
      builder: (BuildContext context, T value, Widget child) {
        return widget.builder(context, value, onChange);
      },
    );
  }

  /// This method is used to trigger all the associated notifiers
  /// when associated value is changed in cache
  void onChange(T newValue) {
    _notifiers[cacheKey].forEach((notifier) {
      notifier.value = newValue;
    });
  }
}
