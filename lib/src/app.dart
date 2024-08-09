import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presentation_timer/src/settings/settings_view.dart';
import 'package:provider/provider.dart';

import 'presentation_timers/presentation_view.dart';
import 'presentation_timers/presentations_controller.dart';
import 'presentation_timers/presentations_list.dart';
import 'settings/settings_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
    required this.presentationsController,
  });

  final SettingsController settingsController;
  final PresentationsController presentationsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
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

          theme: ThemeData(textTheme: GoogleFonts.robotoMonoTextTheme(ThemeData().textTheme)), 
          darkTheme: ThemeData.dark().copyWith(textTheme: GoogleFonts.robotoMonoTextTheme(ThemeData.dark().textTheme)),
          themeMode: settingsController.themeMode,

          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                return ChangeNotifierProvider<PresentationsController>.value(
                  value: presentationsController,
                  child: ListenableBuilder(
                    listenable: presentationsController,
                    builder: (BuildContext context, Widget? child) {
                      final id = (routeSettings.arguments as String?);
                      final presentation = presentationsController.presentations.where((x) => x.id == id).firstOrNull;
                      if (routeSettings.name == PresentationView.routeName && presentation != null) {
                        return PresentationView(presentation: presentation);
                      }
                      if (routeSettings.name == SettingsView.routeName) {
                        return SettingsView(controller: settingsController);
                      }
                      return PresentationListView(presentations: presentationsController.presentations);
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
