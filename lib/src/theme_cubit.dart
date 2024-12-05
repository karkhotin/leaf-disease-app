import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';

class ThemeCubit extends Cubit<AppTheme> {
  late final StreamSubscription _themeSubscription;

  ThemeCubit(Stream<AppTheme> themeStream) : super(AppTheme.system) {
    _themeSubscription = themeStream.listen((theme) {
      emit(theme);
    });
  }

  @override
  Future<void> close() {
    _themeSubscription.cancel();
    return super.close();
  }
}
