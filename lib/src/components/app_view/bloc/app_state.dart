import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';
import 'package:equatable/equatable.dart';

final class AppState extends Equatable {
  final AppTheme appTheme;

  const AppState({this.appTheme = AppTheme.system});

  @override
  List<Object?> get props => [appTheme];
}
