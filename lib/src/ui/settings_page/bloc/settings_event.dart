import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';
import 'package:leaf_disease_app/src/ui/settings_page/bloc/settings_state.dart';

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

final class SettingsLiveDetectionToggled extends SettingsEvent {
  const SettingsLiveDetectionToggled();
}

final class SettingsLeafTypeChanged extends SettingsEvent {
  final LeafType newLeafType;

  const SettingsLeafTypeChanged(this.newLeafType);
}
