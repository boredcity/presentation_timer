import 'package:flutter/material.dart';
import 'package:presentation_timer/src/presentation_timers/models/presentation.dart';
import 'package:presentation_timer/src/presentation_timers/presentation_view.dart';
import 'package:presentation_timer/src/presentation_timers/presentations_controller.dart';
import 'package:provider/provider.dart';

import 'create_presentation_with_name_dialog.dart';
import '../settings/settings_view.dart';

class PresentationListView extends StatelessWidget {
  const PresentationListView({
    super.key,
    required this.presentations,
  });

  static const routeName = '/';

  final List<Presentation> presentations;

  Future<void> _displayTextInputDialog(BuildContext context, PresentationsController controller) async {
    return showDialog(
      context: context,
      builder: (context) {
        return CreatePresentationWithNameDialog(
            onCreatePresentation: (name) => controller.createPresentation(Presentation(name: name)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PresentationsController>(builder: (context, controller, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Select Presentation'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              onPressed: () => Navigator.restorablePushNamed(context, SettingsView.routeName),
            ),
            IconButton(
              icon: const Icon(Icons.add_to_photos_outlined),
              onPressed: () {
                _displayTextInputDialog(context, controller);
              },
            ),
          ],
        ),
        body: ListView.builder(
          restorationId: 'PresentationListView',
          itemCount: presentations.length,
          itemBuilder: (BuildContext itemBuilderContext, int index) {
            final item = presentations[index];
            return ListTile(
              title: Text(item.name),
              leading: const Icon(Icons.timer),
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Delete Presentation'),
                    content: Text('Are you sure you want to delete the presentation "${item.name}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await controller.removePresentation(item.id);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
              onTap: () {
                Navigator.restorablePushNamed(
                  context,
                  PresentationView.routeName,
                  arguments: item.id,
                );
              },
            );
          },
        ),
      );
    });
  }
}
