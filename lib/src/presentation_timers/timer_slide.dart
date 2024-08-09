import 'package:flutter/material.dart';
import 'package:presentation_timer/src/extensions/int.dart';

class TimerSlide extends StatefulWidget {
  const TimerSlide({
    super.key,
    required Duration duration,
    required Color colorFrom,
    required Color colorTo,
    required int timePassed,
    required bool isTimerActive,
    required String text,
  })  : _duration = duration,
        _colorFrom = colorFrom,
        _colorTo = colorTo,
        _timePassed = timePassed,
        _text = text,
        _isTimerActive = isTimerActive;

  final Color _colorFrom;
  final Color _colorTo;
  final Duration _duration;
  final int _timePassed;
  final bool _isTimerActive;
  final String _text;

  @override
  State<TimerSlide> createState() => _TimerSlideState();
}

class _TimerSlideState extends State<TimerSlide> with SingleTickerProviderStateMixin {
  int get _remainingSeconds => widget._duration.inSeconds - widget._timePassed;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget._duration, vsync: this);
    _controller.value = widget._timePassed / widget._duration.inSeconds;
    if (widget._isTimerActive) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant TimerSlide oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._isTimerActive != oldWidget._isTimerActive) {
      if (widget._isTimerActive) {
        _controller.value = widget._timePassed / widget._duration.inSeconds;
        _controller.forward();
      } else {
        _controller.stop(canceled: true);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [widget._colorTo, widget._colorFrom],
                stops: [_controller.value, _controller.value],
              ),
            ),
            child: Center(
                child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 500),
              style: DefaultTextStyle.of(context)
                  .style
                  .apply(color: _remainingSeconds <= 0 ? Colors.white : Colors.black, fontSizeFactor: 4.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(widget._text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 30)),
                Text("${_remainingSeconds.getHumanReadableDuration(forceConsistentPadding: true)} "),
              ]),
            )),
          ),
        );
      },
    );
  }
}
