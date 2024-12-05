import 'package:flutter/material.dart';
import 'package:leaf_disease_app/src/domain/settings/data_provider/settings_shared_preferences_data_provider.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings_repository_impl.dart';
import 'package:leaf_disease_app/src/domain/dease_classification/leaf_dease_classifier_impl.dart';
import 'package:leaf_disease_app/src/domain/leaf_dease_detection_repository.dart';
import 'package:leaf_disease_app/src/domain/leaf_detection/leaf_detector_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  WidgetsFlutterBinding.ensureInitialized();

  final prefsWithCache = await SharedPreferencesWithCache.create(cacheOptions: SharedPreferencesWithCacheOptions());
  final settingsDataProvider = SettingsSharedPreferencesDataProvider(prefsWithCache: prefsWithCache);
  final settingsRepository = SettingsRepositoryImpl(dataProvider: settingsDataProvider);
  await settingsRepository.load();

  final leafDetector = LeafDetectorImpl();
  final leafDeaseClassifier = LeafDeaseClassifierImpl();
  final leafDeaseDetectionRepository = LeafDeaseDetectionRepositoryImpl(
    leafDetector: leafDetector,
    leafDeaseClassifier: leafDeaseClassifier,
  );

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(App(settingsRepository: settingsRepository, leafDeaseDetectionRepository: leafDeaseDetectionRepository));
}
