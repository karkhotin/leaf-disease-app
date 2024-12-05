import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_disease_app/src/components/app_view/bloc/app_state.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings_repository.dart';

class AppCubit extends Cubit<AppState> {
  final SettingsRepository settingsRepository;

  StreamSubscription? _settingsSubscription;

  AppCubit({required this.settingsRepository}) : super(AppState());

  void load() {
    _settingsSubscription = settingsRepository.getSettingsStream().listen((settings) {
      emit(AppState(
        theme: settings.theme,
        language: settings.language,
      ));
    });
  }

  @override
  Future<void> close() {
    _settingsSubscription?.cancel();
    return super.close();
  }
}
