import 'package:leaf_disease_app/src/domain/settings/data_provider/settings_data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class SettingsSharedPreferencesDataProvider extends SettingsDataProvider {
  final SharedPreferencesWithCache prefsWithCache;

  SettingsSharedPreferencesDataProvider({required this.prefsWithCache});

  @override
  Future<String?> getString(String key) async {
    return prefsWithCache.getString(key);
  }

  @override
  Future<int?> getInt(String key) async {
    return prefsWithCache.getInt(key);
  }

  @override
  Future<bool?> getBool(String key) async {
    return prefsWithCache.getBool(key);
  }

  @override
  Future<void> setString(String key, String value) {
    return prefsWithCache.setString(key, value);
  }

  @override
  Future<void> setInt(String key, int value) {
    return prefsWithCache.setInt(key, value);
  }

  @override
  Future<void> setBool(String key, bool value) {
    return prefsWithCache.setBool(key, value);
  }
}
