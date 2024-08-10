import 'package:flutter/material.dart';

class PressableBottomSection extends StatelessWidget {
  const PressableBottomSection({
    super.key,
    required this.text,
    required this.onTap,
    required this.onLongPress,
  });

  final String text;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * (1 / 3),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 60, color: Colors.grey.withOpacity(0.2)),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
