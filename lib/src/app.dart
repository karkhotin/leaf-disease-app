import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_disease_app/src/components/app_view/bloc/app_cubit.dart';
import 'package:leaf_disease_app/src/components/app_view/ui/app_view.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings_repository.dart';
import 'package:leaf_disease_app/src/domain/dease_detection/leaf_dease_detection_repository.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.settingsRepository,
    required this.leafDeaseDetectionRepository,
  });

  final SettingsRepository settingsRepository;
  final LeafDeaseDetectionRepository leafDeaseDetectionRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: settingsRepository),
        RepositoryProvider.value(value: leafDeaseDetectionRepository),
      ],
      child: BlocProvider(
        create: (context) => AppCubit(settingsRepository: settingsRepository)..load(),
        child: const AppView(),
      ),
    );
  }
}
