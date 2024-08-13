import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';

class CreateSlideWithNameAndTimeDialog extends StatefulWidget {
  final Function(String name, Duration duration) onCreateSlide;

  const CreateSlideWithNameAndTimeDialog({
    super.key,
    required this.onCreateSlide,
  });

  @override
  State<CreateSlideWithNameAndTimeDialog> createState() => _CreateSlideWithNameAndTimeDialogState();
}

class _CreateSlideWithNameAndTimeDialogState extends State<CreateSlideWithNameAndTimeDialog> {
  final TextEditingController _textFieldController;

  _CreateSlideWithNameAndTimeDialogState() : _textFieldController = TextEditingController();

  Duration _duration = const Duration(minutes: 0, seconds: 30);

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Slide'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: "Slide Name"),
          ),
          DurationPicker(
            lowerBound: const Duration(seconds: 5),
            upperBound: const Duration(minutes: 9, seconds: 59),
            baseUnit: BaseUnit.second,
            duration: _duration,
            onChange: (val) {
              setState(() => _duration = val);
            },
          )
        ],
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
            widget.onCreateSlide(_textFieldController.text, _duration);
          },
        ),
      ],
    );
  }
}
