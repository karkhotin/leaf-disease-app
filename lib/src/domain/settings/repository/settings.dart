import 'package:copy_with_extension/copy_with_extension.dart';

part 'settings.g.dart';

enum AppTheme { system, light, dark }

enum LeafType { apple, apricot, cherry, grape, peach, pear, walnut }

@CopyWith()
final class AppSettings {
  final AppTheme theme;
  final bool isLiveDetectionEnabled;
  final LeafType activeLeafType;

  const AppSettings({
    AppTheme? theme,
    bool? isLiveDetectionEnabled,
    LeafType? activeLeafType,
  })  : theme = theme ?? AppTheme.system,
        isLiveDetectionEnabled = isLiveDetectionEnabled ?? true,
        activeLeafType = activeLeafType ?? LeafType.apple;
}
