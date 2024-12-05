import 'dart:ui';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';

extension LocalizationUtils on AppLocalizations {
  String leafType(LeafType leafType) {
    switch (leafType) {
      case LeafType.apple:
        return leafType_apple;
      case LeafType.apricot:
        return leafType_apricot;
      case LeafType.cherry:
        return leafType_cherry;
      case LeafType.grape:
        return leafType_grape;
      case LeafType.peach:
        return leafType_peach;
      case LeafType.pear:
        return leafType_pear;
      case LeafType.walnut:
        return leafType_walnut;
    }
  }

  String leafDisease(String label) {
    switch (label) {
      case 'Healthy':
        return disease_healthy;
      case 'Black measles':
        return disease_BlackMeasles;
      case 'Black rot':
        return disease_BlackRot;
      case 'Leaf blight':
        return disease_LeafBlight;
      default:
        return label;
    }
  }
}

extension AppLanguageExtension on AppLanguage {
  Locale? get locale {
    switch (this) {
      case AppLanguage.english:
        return const Locale('en');
      case AppLanguage.ukrainian:
        return const Locale('uk');
      default:
        return null;
    }
  }
}
