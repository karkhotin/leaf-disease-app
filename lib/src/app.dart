import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings_repository.dart';
import 'package:leaf_disease_app/src/domain/leaf_dease_detection_repository.dart';
import 'package:leaf_disease_app/src/theme_cubit.dart';
import 'package:leaf_disease_app/src/ui/home_page.dart';

import 'sample_feature/sample_item_details_view.dart';
import 'sample_feature/sample_item_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class App extends StatelessWidget {
  const App({
    super.key,
    required this.settingsRepository,
    required this.leafDeaseDetectionRepository,
  });

  final SettingsRepository settingsRepository;
  final LeafDeaseDetectionRepository leafDeaseDetectionRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: settingsRepository),
        RepositoryProvider.value(value: leafDeaseDetectionRepository),
      ],
      child: BlocProvider(
        create: (context) => ThemeCubit(settingsRepository.getSettingsStream().map((settings) => settings.theme)),
        child: const AppView(),
      ),
    );

    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    // return ListenableBuilder(
    //   listenable: settingsController,
    //   builder: (BuildContext context, Widget? child) {
    //     return MaterialApp(
    //       // Providing a restorationScopeId allows the Navigator built by the
    //       // MaterialApp to restore the navigation stack when a user leaves and
    //       // returns to the app after it has been killed while running in the
    //       // background.
    //       restorationScopeId: 'app',

    //       // Provide the generated AppLocalizations to the MaterialApp. This
    //       // allows descendant Widgets to display the correct translations
    //       // depending on the user's locale.
    //       localizationsDelegates: const [
    //         AppLocalizations.delegate,
    //         GlobalMaterialLocalizations.delegate,
    //         GlobalWidgetsLocalizations.delegate,
    //         GlobalCupertinoLocalizations.delegate,
    //       ],
    //       supportedLocales: const [
    //         Locale('en', ''), // English, no country code
    //       ],

    //       // Use AppLocalizations to configure the correct application title
    //       // depending on the user's locale.
    //       //
    //       // The appTitle is defined in .arb files found in the localization
    //       // directory.
    //       onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,

    //       // Define a light and dark color theme. Then, read the user's
    //       // preferred ThemeMode (light, dark, or system default) from the
    //       // SettingsController to display the correct theme.
    //       theme: ThemeData(),
    //       darkTheme: ThemeData.dark(),
    //       themeMode: settingsController.themeMode,

    //       // Define a function to handle named routes in order to support
    //       // Flutter web url navigation and deep linking.
    //       onGenerateRoute: (RouteSettings routeSettings) {
    //         return MaterialPageRoute<void>(
    //           settings: routeSettings,
    //           builder: (BuildContext context) {
    //             switch (routeSettings.name) {
    //               case SettingsView.routeName:
    //                 return SettingsView(controller: settingsController);
    //               case SampleItemDetailsView.routeName:
    //                 return const SampleItemDetailsView();
    //               case SampleItemListView.routeName:
    //               default:
    //                 return const HomePage();
    //               // return const SampleItemListView();
    //             }
    //           },
    //         );
    //       },
    //     );
    //   },
    // );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(
      builder: (context, state) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: _themeModeFromAppTheme(state),

          home: const HomePage(),
        );
      },
    );
  }

  ThemeMode _themeModeFromAppTheme(AppTheme theme) {
    switch (theme) {
      case AppTheme.system:
        return ThemeMode.system;
      case AppTheme.light:
        return ThemeMode.light;
      case AppTheme.dark:
        return ThemeMode.dark;
    }
  }
}
