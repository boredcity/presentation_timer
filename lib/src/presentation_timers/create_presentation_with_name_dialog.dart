import 'package:flutter/material.dart';

class CreatePresentationWithNameDialog extends StatefulWidget {
  final Function(String name) onCreatePresentation;

  const CreatePresentationWithNameDialog({
    super.key,
    required this.onCreatePresentation,
  });

  @override
  State<CreatePresentationWithNameDialog> createState() => _CreatePresentationWithNameDialogState();
}

class _CreatePresentationWithNameDialogState extends State<CreatePresentationWithNameDialog> {
  final TextEditingController _textFieldController;

  _CreatePresentationWithNameDialogState() : _textFieldController = TextEditingController();

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Presentation'),
      content: TextField(
        controller: _textFieldController,
        decoration: const InputDecoration(hintText: "New Presentation Name"),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('Create'),
          onPressed: () async {
            Navigator.pop(context);
            widget.onCreatePresentation(_textFieldController.text);
          },
        ),
      ],
    );
  }
}
