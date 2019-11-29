abstract class CacheProvider {
  CacheProvider() {
    init();
  }

  void init();

  int getInt(String key);

  String getString(String key);

  double getDouble(String key);

  bool getBool(String key);

  void setInt(String key, int value);

  void setString(String key, String value);

  void setDouble(String key, double value);

  void setBool(String key, bool value);

  bool containsKey(String key);

  Set<E> getKeys<E>();

  void remove(String key);

  void removeAll();

  dynamic getValue(String settingsKey);
}
