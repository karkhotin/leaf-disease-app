import 'package:flutter/material.dart';
import 'package:leaf_disease_app/src/domain/disease_classification/classifier_factory/leaf_disease_tflite_classifier_provider.dart';
import 'package:leaf_disease_app/src/domain/disease_detection/leaf_disease_detection_repository_impl.dart';
import 'package:leaf_disease_app/src/domain/settings/data_provider/settings_shared_preferences_data_provider.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings_repository_impl.dart';
import 'package:leaf_disease_app/src/domain/leaf_detection/leaf_torch_detector.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefsWithCache = await SharedPreferencesWithCache.create(cacheOptions: SharedPreferencesWithCacheOptions());
  final settingsDataProvider = SettingsSharedPreferencesDataProvider(prefsWithCache: prefsWithCache);
  final settingsRepository = SettingsRepositoryImpl(dataProvider: settingsDataProvider);
  await settingsRepository.load();

  final leafDetector = LeafTorchDetector();
  final leafDiseaseClassifierProvider = LeafDiseaseTfLiteClassifierProvider();
  final leafDiseaseDetectionRepository = LeafDiseaseDetectionRepositoryImpl(
    leafDetector: leafDetector,
    leafDiseaseClassifierProvider: leafDiseaseClassifierProvider,
  );

  runApp(App(settingsRepository: settingsRepository, leafDiseaseDetectionRepository: leafDiseaseDetectionRepository));
}
