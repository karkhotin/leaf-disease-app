import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings_repository.dart';
import 'package:leaf_disease_app/src/components/settings_page/bloc/settings_event.dart';
import 'package:leaf_disease_app/src/components/settings_page/bloc/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsBloc({required this.settingsRepository}) : super(SettingsState()) {
    on<SettingsLoadRequested>(_onLoadRequested);
    on<SettingsThemeChanged>(_onThemeChanged);
    on<SettingsLiveDetectionToggled>(_onLiveDetectionToggled);
    on<SettingsLeafTypeChanged>(_onLeafTypeChanged);
  }

  Future<void> _onLoadRequested(
    SettingsLoadRequested event,
    Emitter<SettingsState> emit,
  ) async {
    await emit.forEach(settingsRepository.getSettingsStream(),
        onData: (appSettings) => SettingsState(appSettings: appSettings));
  }

  Future<void> _onThemeChanged(
    SettingsThemeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    settingsRepository.setTheme(event.newTheme);
  }

  Future<void> _onLiveDetectionToggled(
    SettingsLiveDetectionToggled event,
    Emitter<SettingsState> emit,
  ) async {
    settingsRepository.setLiveDetectionEnabled(!state.appSettings!.isLiveDetectionEnabled);
  }

  Future<void> _onLeafTypeChanged(
    SettingsLeafTypeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    settingsRepository.setActiveLeafType(event.newLeafType);
  }
}
