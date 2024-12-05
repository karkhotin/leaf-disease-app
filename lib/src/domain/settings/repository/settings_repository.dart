import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';

abstract class SettingsRepository {
  Future<void> setTheme(AppTheme theme);

  Future<void> setLiveDetectionEnabled(bool enabled);

  Future<void> setActiveLeafType(LeafType leafType);

  Stream<AppSettings> getSettingsStream();

  AppSettings get settings;
}
