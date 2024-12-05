import 'package:copy_with_extension/copy_with_extension.dart';

part 'settings.g.dart';

enum AppTheme { system, light, dark }

enum AppLanguage { system, english, ukrainian }

enum LeafType { apple, apricot, cherry, grape, peach, pear, walnut }

@CopyWith()
final class AppSettings {
  final AppTheme theme;
  final AppLanguage language;
  final bool isLiveDetectionEnabled;
  final LeafType activeLeafType;

  const AppSettings({
    AppTheme? theme,
    AppLanguage? language,
    bool? isLiveDetectionEnabled,
    LeafType? activeLeafType,
  })  : theme = theme ?? AppTheme.system,
        language = language ?? AppLanguage.system,
        isLiveDetectionEnabled = isLiveDetectionEnabled ?? true,
        activeLeafType = activeLeafType ?? LeafType.apple;
}
