import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';

sealed class SettingsEvent {
  const SettingsEvent();
}

final class SettingsLoadRequested extends SettingsEvent {
  const SettingsLoadRequested();
}

final class SettingsThemeChanged extends SettingsEvent {
  final AppTheme newTheme;

  const SettingsThemeChanged(this.newTheme);
}

final class SettingsLanguageChanged extends SettingsEvent {
  final AppLanguage newLanguage;

  const SettingsLanguageChanged(this.newLanguage);
}

final class SettingsLiveDetectionToggled extends SettingsEvent {
  const SettingsLiveDetectionToggled();
}

final class SettingsLeafTypeChanged extends SettingsEvent {
  final LeafType newLeafType;

  const SettingsLeafTypeChanged(this.newLeafType);
}
