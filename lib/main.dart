import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/presentation_timers/presentations_controller.dart';
import 'src/presentation_timers/presentations_service.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  final presentationsController = PresentationsController(PresentationsService());
  await presentationsController.loadPresentations();

  runApp(MyApp(settingsController: settingsController, presentationsController: presentationsController));
}
