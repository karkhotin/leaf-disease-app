import 'package:leaf_disease_app/src/domain/settings/data_provider/settings_data_provider.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings_repository.dart';
import 'package:rxdart/subjects.dart';

final class SettingsRepositoryImpl extends SettingsRepository {
  final SettingsDataProvider _dataProvider;

  late final _settingsStreamController = BehaviorSubject<AppSettings>.seeded(
    const AppSettings(),
  );

  @override
  AppSettings get settings => _settingsStreamController.value;

  SettingsRepositoryImpl({required SettingsDataProvider dataProvider}) : _dataProvider = dataProvider;

  Future<void> load() async {
    final values = await Future.wait([
      _dataProvider.getInt(_SettingsKeys.appThemeKey),
      _dataProvider.getInt(_SettingsKeys.appLanguageKey),
      _dataProvider.getBool(_SettingsKeys.liveDetectionEnabledKey),
      _dataProvider.getInt(_SettingsKeys.activeLeafTypeKey),
    ]);
    final settings = AppSettings(
      theme: values[0] is int ? AppTheme.values[values[0] as int] : null,
      language: values[1] is int ? AppLanguage.values[values[1] as int] : null,
      isLiveDetectionEnabled: values[2] is bool ? values[2] as bool : null,
      activeLeafType: values[3] is int ? LeafType.values[values[3] as int] : null,
    );
    _settingsStreamController.add(settings);
  }

  @override
  Stream<AppSettings> getSettingsStream() => _settingsStreamController.asBroadcastStream();

  @override
  Future<void> setLiveDetectionEnabled(bool enabled) {
    _settingsStreamController.add(_settingsStreamController.value.copyWith(isLiveDetectionEnabled: enabled));
    return _dataProvider.setBool(_SettingsKeys.liveDetectionEnabledKey, enabled);
  }

  @override
  Future<void> setTheme(AppTheme theme) {
    _settingsStreamController.add(_settingsStreamController.value.copyWith(theme: theme));
    return _dataProvider.setInt(_SettingsKeys.appThemeKey, theme.index);
  }

  @override
  Future<void> setLanguage(AppLanguage language) {
    _settingsStreamController.add(_settingsStreamController.value.copyWith(language: language));
    return _dataProvider.setInt(_SettingsKeys.appLanguageKey, language.index);
  }

  @override
  Future<void> setActiveLeafType(LeafType leafType) {
    _settingsStreamController.add(_settingsStreamController.value.copyWith(activeLeafType: leafType));
    return _dataProvider.setInt(_SettingsKeys.activeLeafTypeKey, leafType.index);
  }
}

abstract class _SettingsKeys {
  static String appThemeKey = "app_theme";
  static String appLanguageKey = "app_language";
  static String liveDetectionEnabledKey = "live_detection_enabled";
  static String activeLeafTypeKey = "active_leaf_type";
}
