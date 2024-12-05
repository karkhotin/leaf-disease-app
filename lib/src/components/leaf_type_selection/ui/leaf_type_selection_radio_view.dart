import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_disease_app/src/components/leaf_type_selection/bloc/leaf_type_selection_bloc.dart';
import 'package:leaf_disease_app/src/components/leaf_type_selection/bloc/leaf_type_selection_event.dart';
import 'package:leaf_disease_app/src/components/leaf_type_selection/bloc/leaf_type_selection_state.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';
import 'package:leaf_disease_app/src/utils/localization_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LeafTypeSelectionRadioView extends StatelessWidget {
  const LeafTypeSelectionRadioView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LeafTypeSelectionBloc(settingsRepository: context.read())..add(LeafTypeSelectionLoadRequested()),
      child: const _LeafTypeRadioButton(),
    );
  }
}

class _LeafTypeRadioButton extends StatelessWidget {
  const _LeafTypeRadioButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeafTypeSelectionBloc, LeafTypeSelectionState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.settingsLeafType,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            ...List<Widget>.generate(LeafType.values.length, (int index) {
              return RadioListTile(
                title: Text(
                  AppLocalizations.of(context)!.leafType(LeafType.values[index]),
                  style: TextStyle(fontSize: 18),
                ),
                value: LeafType.values[index],
                groupValue: state.selectedLeafType,
                onChanged: (LeafType? type) =>
                    type != null ? context.read<LeafTypeSelectionBloc>().add(LeafTypeSelectionChanged(type)) : (),
                contentPadding: EdgeInsets.all(0),
              );
            })
          ],
        );
      },
    );
  }
}
