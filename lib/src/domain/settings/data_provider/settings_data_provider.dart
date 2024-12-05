abstract class SettingsDataProvider {
  Future<String?> getString(String key);

  Future<int?> getInt(String key);

  Future<bool?> getBool(String key);

  Future<void> setString(String key, String value);

  Future<void> setInt(String key, int value);

  Future<void> setBool(String key, bool value);
}
