import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';

sealed class LeafTypeSelectionEvent {
  const LeafTypeSelectionEvent();
}

final class LeafTypeSelectionLoadRequested extends LeafTypeSelectionEvent {
  const LeafTypeSelectionLoadRequested();
}

final class LeafTypeSelectionChanged extends LeafTypeSelectionEvent {
  final LeafType leafType;

  const LeafTypeSelectionChanged(this.leafType);
}
