import 'package:flutter/material.dart';

import 'cache_provider.dart';

typedef WidgetBuilder<T> = Widget Function(
    BuildContext context, T value, OnChangeCallBack<T> onChange);

typedef SimpleWidgetBuilder<T> = Widget Function(T value);

typedef OnChangeCallBack<T> = void Function(T value);

class Settings {
  static final Settings _instance = Settings._internal();

  factory Settings() {
    assert(
        _cacheProvider != null,
        'Must call Settings.init(cacheProvider)'
        ' before using settings!');
    return _instance;
  }

  Settings._internal();

  static CacheProvider _cacheProvider;

  static void init(CacheProvider cacheProvider) {
    _cacheProvider = cacheProvider;
  }

  static bool containsKey(String key) {
    assert(key != null);
    return _cacheProvider.containsKey(key);
  }

  static T getValue<T>(String key, T defaultValue) {
    assert(key != null);
    if (_cacheProvider.containsKey(key)) {
      return _cacheProvider.getValue<T>(key, defaultValue);
    }
    return defaultValue;
  }

  static void setValue<T>(String key, T value) {
    if (value == null) {
      return _cacheProvider.remove(key);
    }
    _cacheProvider.setObject<T>(key, value);
  }

  static void clearCache() {
    assert(
    _cacheProvider != null,
    'CacheProvider is not set.'
        '\n Please Call `Settings.init()` before using settings!!');
    _cacheProvider.removeAll();
  }
}

class ValueChangeNotifier<T> extends ValueNotifier<T> {
  final String key;

  ValueChangeNotifier(value,
      this.key,) : super(value);

  @override
  set value(T newValue) {
    Settings.setValue<T>(key, newValue);
    super.value = newValue;
  }

  @override
  void notifyListeners() {
    debugPrint('\n===============================================\n');
//    debugPrint('Notifying listeners: for'
//        '\n new value: $value \n\n${StackTrace.current}');
    debugPrint('Notifying listeners: new value: $value');
    debugPrint('CurrentStatus : $_notifiers');
    debugPrint('\n===============================================\n');
    super.notifyListeners();
  }

  @override
  String toString() {
    return '\n{VCN: \n\tkey: $key  \n\tvalue: $value\n}';
  }
}

Map<String, ValueChangeNotifier> _notifiers =
Map<String, ValueChangeNotifier>();

class CacheChangeObserver<T> extends StatefulWidget {
  final String cacheKey;
  final T defaultValue;
  final WidgetBuilder<T> builder;

  const CacheChangeObserver({
    Key key,
    @required this.cacheKey,
    @required this.defaultValue,
    @required this.builder,
  }) : super(key: key);

  @override
  _CacheChangeObserverState<T> createState() => _CacheChangeObserverState<T>();
}

class _CacheChangeObserverState<T> extends State<CacheChangeObserver<T>> {
  T value;

  String get cacheKey => widget.cacheKey;

  T get defaultValue => widget.defaultValue;

  WidgetBuilder<T> get builder => widget.builder;

  ValueChangeNotifier<T> get notifier =>
      _notifiers[cacheKey] as ValueChangeNotifier<T>;

  @override
  void initState() {
    super.initState();
    if (!Settings.containsKey(cacheKey)) {
      Settings.setValue<T>(cacheKey, defaultValue);
    }
    value = Settings.getValue<T>(cacheKey, defaultValue);
    ValueChangeNotifier<T> notifier = ValueChangeNotifier<T>(value, cacheKey);
    _notifiers[cacheKey] = notifier;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('creating ValueChangeNotifier for:'
        '\n  key: $cacheKey and value: $value');
    return ValueListenableBuilder<T>(
      valueListenable: notifier,
      builder: (BuildContext context, T value, Widget child) {
        return builder(context, value, onChange);
      },
    );
  }

  void onChange(T newValue) {
    notifier.value = newValue;
  }
}
