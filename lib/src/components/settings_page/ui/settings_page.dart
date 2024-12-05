import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';
import 'package:leaf_disease_app/src/components/settings_page/bloc/settings_bloc.dart';
import 'package:leaf_disease_app/src/components/settings_page/bloc/settings_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leaf_disease_app/src/components/settings_page/bloc/settings_state.dart';
import 'package:leaf_disease_app/src/utils/localization_utils.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => SettingsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(
        settingsRepository: context.read(),
      )..add(const SettingsLoadRequested()),
      child: SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle),
      ),
      body: SafeArea(
          child: Column(
        children: [
          _wrapRow(_themeRow(context)),
          Divider(),
          _wrapRow(_languageRow(context)),
          Divider(),
          _wrapRow(_liveDetectionRow(context)),
          Divider(),
          _wrapRow(_leafTypeRow(context)),
        ],
      )),
    );
  }

  Widget _wrapRow(Widget row) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: row,
    );
  }

  Widget _themeRow(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) => previous.appSettings?.theme != current.appSettings?.theme,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.settingsTheme),
            DropdownButton<AppTheme>(
              value: state.appSettings?.theme ?? AppTheme.system,
              onChanged: (theme) => theme != null ? context.read<SettingsBloc>().add(SettingsThemeChanged(theme)) : (),
              items: [
                DropdownMenuItem(
                  value: AppTheme.system,
                  child: Text(AppLocalizations.of(context)!.settingsThemeSystem),
                ),
                DropdownMenuItem(
                  value: AppTheme.light,
                  child: Text(AppLocalizations.of(context)!.settingsThemeLight),
                ),
                DropdownMenuItem(
                  value: AppTheme.dark,
                  child: Text(AppLocalizations.of(context)!.settingsThemeDark),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget _languageRow(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) => previous.appSettings?.language != current.appSettings?.language,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.settingsLanguage),
            DropdownButton<AppLanguage>(
              value: state.appSettings?.language ?? AppLanguage.system,
              onChanged: (language) =>
                  language != null ? context.read<SettingsBloc>().add(SettingsLanguageChanged(language)) : (),
              items: [
                DropdownMenuItem(
                  value: AppLanguage.system,
                  child: Text(AppLocalizations.of(context)!.settingsThemeSystem),
                ),
                DropdownMenuItem(
                  value: AppLanguage.english,
                  child: Text(AppLocalizations.of(context)!.settingsLanguage_en),
                ),
                DropdownMenuItem(
                  value: AppLanguage.ukrainian,
                  child: Text(AppLocalizations.of(context)!.settingsLanguage_uk),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget _liveDetectionRow(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) =>
          previous.appSettings?.isLiveDetectionEnabled != current.appSettings?.isLiveDetectionEnabled,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.settingsLiveDetection),
            Switch(
              value: state.appSettings?.isLiveDetectionEnabled ?? false,
              onChanged: (value) => context.read<SettingsBloc>().add(SettingsLiveDetectionToggled()),
            ),
          ],
        );
      },
    );
  }

  Widget _leafTypeRow(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) => previous.appSettings?.activeLeafType != current.appSettings?.activeLeafType,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.settingsLeafType),
            DropdownButton<LeafType>(
              value: state.appSettings?.activeLeafType ?? LeafType.apple,
              onChanged: (type) => type != null ? context.read<SettingsBloc>().add(SettingsLeafTypeChanged(type)) : (),
              items: [
                _leafTypeDropdownItem(context, LeafType.apple),
                _leafTypeDropdownItem(context, LeafType.apricot),
                _leafTypeDropdownItem(context, LeafType.cherry),
                _leafTypeDropdownItem(context, LeafType.grape),
                _leafTypeDropdownItem(context, LeafType.peach),
                _leafTypeDropdownItem(context, LeafType.pear),
                _leafTypeDropdownItem(context, LeafType.walnut),
              ],
            )
          ],
        );
      },
    );
  }

  DropdownMenuItem<LeafType> _leafTypeDropdownItem(BuildContext context, LeafType leafType) {
    return DropdownMenuItem(
      value: leafType,
      child: Text(AppLocalizations.of(context)!.leafType(leafType)),
    );
  }
}
