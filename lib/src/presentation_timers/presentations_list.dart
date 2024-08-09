import 'package:flutter/material.dart';
import 'package:presentation_timer/src/presentation_timers/models/presentation.dart';
import 'package:presentation_timer/src/presentation_timers/presentation_view.dart';
import 'package:presentation_timer/src/presentation_timers/presentations_controller.dart';

import '../settings/settings_view.dart';

class PresentationListView extends StatelessWidget {
  const PresentationListView({
    super.key, required this.presentations,
  });

  static const routeName = '/';

  final List<Presentation> presentations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Presentation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_to_photos_outlined),
            onPressed: () => PresentationsController.of(context).createPresentation(Presentation()),
          ),
        ],
      ),
      body: ListView.builder(
        restorationId: 'PresentationListView',
        itemCount: presentations.length,
        itemBuilder: (BuildContext context, int index) {
          final item = presentations[index];

          return ListTile(
              title: Text(item.name),
              leading: const Icon(Icons.timer),
              onTap: () {
                Navigator.restorablePushNamed(
                  context,
                  PresentationView.routeName,
                  arguments: item.id,
                );
              });
        },
      ),
    );
  }
}
