import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';
import 'package:equatable/equatable.dart';

final class AppState extends Equatable {
  final AppTheme theme;
  final AppLanguage language;

  const AppState({
    this.theme = AppTheme.system,
    this.language = AppLanguage.system,
  });

  @override
  List<Object?> get props => [
        theme,
        language,
      ];
}
