import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_disease_app/src/components/leaf_type_selection/bloc/leaf_type_selection_event.dart';
import 'package:leaf_disease_app/src/components/leaf_type_selection/bloc/leaf_type_selection_state.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings_repository.dart';

class LeafTypeSelectionBloc extends Bloc<LeafTypeSelectionEvent, LeafTypeSelectionState> {
  final SettingsRepository settingsRepository;
  LeafTypeSelectionBloc({
    required this.settingsRepository,
  }) : super(LeafTypeSelectionState(selectedLeafType: settingsRepository.settings.activeLeafType)) {
    on<LeafTypeSelectionLoadRequested>(_onLoadRequested);
    on<LeafTypeSelectionChanged>(_onSelectionChanged);
  }

  Future<void> _onLoadRequested(
    LeafTypeSelectionLoadRequested event,
    Emitter<LeafTypeSelectionState> emit,
  ) async {
    await emit.forEach(
      settingsRepository.getSettingsStream(),
      onData: (appSettings) => LeafTypeSelectionState(selectedLeafType: appSettings.activeLeafType),
    );
  }

  Future<void> _onSelectionChanged(
    LeafTypeSelectionChanged event,
    Emitter<LeafTypeSelectionState> emit,
  ) async {
    settingsRepository.setActiveLeafType(event.leafType);
  }
}
