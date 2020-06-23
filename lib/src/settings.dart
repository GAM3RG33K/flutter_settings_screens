import 'package:flutter/material.dart';

import 'cache/cache.dart';

/// This function type is used for rebuilding any given child widgets
///
/// All Settings Tile are given a [ValueChangeObserver] with a unique settings key.
///
/// When the value associated with a settings key changes, [ValueChangeObserver]
/// triggers a [InternalWidgetBuilder] function call.
typedef InternalWidgetBuilder<T> = Widget Function(
    BuildContext, T, ValueChanged<T>,
    {ValueChanged<T> onChangeStart, ValueChanged<T> onChangeEnd});

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
        _cacheProvider != null,
        'Must call Settings.init(cacheProvider)'
        ' before using settings!');
  }

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
  static void setValue<T>(String key, T value) {
    ensureCacheProvider();
    if (value == null) {
      return _cacheProvider.remove(key);
    }
    _cacheProvider.setObject<T>(key, value);
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

  final bool updateCache;

  ValueChangeNotifier(this.key, value, this.updateCache) : super(value);

  @override
  set value(T newValue) {
    if (updateCache == true) {
      Settings.setValue<T>(key, newValue);
    }
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
Map<String, List<ValueChangeNotifier>> _onChangedNotifiers =
    Map<String, List<ValueChangeNotifier>>();

Map<String, List<ValueChangeNotifier>> _onChangeStartNotifiers;

Map<String, List<ValueChangeNotifier>> _onChangeEndNotifiers;

/// A Stateful widget which Takes in a [cacheKey], a [defaultValue]
/// and a [builder]
///
/// This widget rebuilds whenever there's a change in value associated with the
/// [cacheKey]
class ValueChangeObserver<T> extends StatefulWidget {
  final String cacheKey;
  final bool updateCacheOnChanged;
  final bool updateCacheOnChangeStart;
  final bool updateCacheOnChangeEnd;
  final T defaultValue;
  final InternalWidgetBuilder<T> builder;

  const ValueChangeObserver({
    @required this.cacheKey,
    @required this.defaultValue,
    @required this.builder,
    this.updateCacheOnChanged = true,
    this.updateCacheOnChangeStart,
    this.updateCacheOnChangeEnd,
  });

  @override
  _ValueChangeObserverState<T> createState() => _ValueChangeObserverState<T>();
}

class _ValueChangeObserverState<T> extends State<ValueChangeObserver<T>> {
  T value;

  String get cacheKey => widget.cacheKey;

  bool get updateCacheOnChanged => widget.updateCacheOnChanged;

  bool get updateCacheOnChangeStart => widget.updateCacheOnChangeStart;

  bool get updateCacheOnChangeEnd => widget.updateCacheOnChangeEnd;

  T get defaultValue => widget.defaultValue;

  ValueChangeNotifier<T> onChangedNotifier;

  ValueChangeNotifier<T> onChangeStartNotifier;

  ValueChangeNotifier<T> onChangeEndNotifier;

  @override
  void initState() {
    super.initState();
    //if [cacheKey] is not found ,add new cache in the [cacheProvider] with [defaultValue]
    if (!Settings.containsKey(cacheKey)) {
      Settings.setValue<T>(cacheKey, defaultValue);
    }

    // get cache value from the [cacheProvider]
    value = Settings.getValue<T>(cacheKey, defaultValue);

    // assign notifiers
    onChangedNotifier =
        ValueChangeNotifier<T>(cacheKey, value, updateCacheOnChanged);
    if (updateCacheOnChangeStart != null) {
      onChangeStartNotifier =
          ValueChangeNotifier<T>(cacheKey, value, updateCacheOnChangeStart);
    }
    if (updateCacheOnChangeEnd != null) {
      onChangeEndNotifier =
          ValueChangeNotifier<T>(cacheKey, value, updateCacheOnChangeEnd);
    }

    // add notifiers to [_notifiers] maps
    if (!_onChangedNotifiers.containsKey(cacheKey)) {
      _onChangedNotifiers[cacheKey] = List<ValueChangeNotifier<T>>();
    }
    _onChangedNotifiers[cacheKey].add(onChangedNotifier);

    if (onChangeStartNotifier != null) {
      if (_onChangeStartNotifiers == null) {
        _onChangeStartNotifiers = Map<String, List<ValueChangeNotifier>>();
      }
      if (!_onChangeStartNotifiers.containsKey(cacheKey)) {
        _onChangeStartNotifiers[cacheKey] = List<ValueChangeNotifier<T>>();
      }
      _onChangeStartNotifiers[cacheKey].add(onChangeStartNotifier);
    }

    if (onChangeEndNotifier != null) {
      if (_onChangeEndNotifiers == null) {
        _onChangeEndNotifiers = Map<String, List<ValueChangeNotifier>>();
      }
      if (!_onChangeEndNotifiers.containsKey(cacheKey)) {
        _onChangeEndNotifiers[cacheKey] = List<ValueChangeNotifier<T>>();
      }
      _onChangeEndNotifiers[cacheKey].add(onChangeEndNotifier);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: onChangedNotifier,
      builder: (BuildContext context, T value, Widget child) {
        return widget.builder(context, value, onChanged,
            onChangeStart: onChangeStart, onChangeEnd: onChangeEnd);
      },
    );
  }

  /// This method is used to trigger all the associated notifiers
  /// when associated value is changed in cache
  void onChanged(T newValue) {
    _onChangedNotifiers[cacheKey].forEach((notifier) {
      notifier.value = newValue;
    });
  }

  void onChangeStart(T newValue) {
    _onChangeStartNotifiers[cacheKey].forEach((notifier) {
      notifier.value = newValue;
    });
  }

  void onChangeEnd(T newValue) {
    _onChangeEndNotifiers[cacheKey].forEach((notifier) {
      notifier.value = newValue;
    });
  }
}
