import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:presentation_timer/src/presentation_timers/models/presentation.dart';
import 'package:presentation_timer/src/presentation_timers/presentations_controller.dart';
import 'package:presentation_timer/src/presentation_timers/timer_slide.dart';
import 'package:presentation_timer/src/extensions/int.dart';

import 'models/slide.dart';

class PresentationView extends StatefulWidget {
  const PresentationView({
    super.key,
    required this.presentation,
  });

  static const routeName = '/presentation';

  final Presentation presentation;

  @override
  State<PresentationView> createState() => _PresentationViewState();
}

class _PresentationViewState extends State<PresentationView> with SingleTickerProviderStateMixin {
  final Map<String, int> _timePassedBySlide = {};
  late Slide? _currentSlide;
  int _secondsPassed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentSlide = widget.presentation.slides.isEmpty ? null : widget.presentation.slides[0];
  }

  void _createTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => setState(
        () {
          _secondsPassed++;

          final currentSlideIdLocal = _currentSlide;
          if (currentSlideIdLocal != null) {
            _timePassedBySlide.update(currentSlideIdLocal.id, (val) => val + 1, ifAbsent: () => 1);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSlideLocal = _currentSlide;
    final totalTimeLeft = widget.presentation.duration.inSeconds - _secondsPassed;

    final differenceWithExpectedTime = expectedTimeSpent - _secondsPassed;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          if (currentSlideLocal != null)
            TimerSlide(
              key: Key(currentSlideLocal.id),
              text: currentSlideLocal.name,
              duration: currentSlideLocal.duration,
              timePassed: _timePassedBySlide[currentSlideLocal.id] ?? 0,
              colorFrom: currentSlideLocal.fromColor,
              colorTo: currentSlideLocal.toColor,
              isTimerActive: _timer?.isActive ?? false,
            )
          else
            const SizedBox.expand(
              child: Center(child: Text("No slides")),
            ),
          AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.add_box_outlined),
                onPressed: () async {
                  await PresentationsController.of(context).updatePresentation(
                    widget.presentation.copyWith(slides: [...widget.presentation.slides, Slide()]),
                  );
                  if (_currentSlide == null) {
                    setState(() {
                      _currentSlide = widget.presentation.slides.firstOrNull;
                    });
                  }
                },
              ),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: widget.presentation.slides.isNotEmpty
                ? Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Text("Total time left: ${totalTimeLeft.getHumanReadableDuration()}",
                        style: const TextStyle(fontSize: 20)),
                    AnimatedOpacity(
                      opacity: differenceWithExpectedTime == 0 ? 0 : 1,
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        differenceWithExpectedTime.getHumanReadableDuration(
                          forceConsistentPadding: true,
                          forceShowSign: true,
                        ),
                        style: TextStyle(
                          color: differenceWithExpectedTime > 0 ? Colors.green.shade800 : Colors.red.shade800,
                          fontSize: 24,
                        ),
                      ),
                    )
                  ])
                : Align(
                    alignment: Alignment.topCenter,
                    child: Text(widget.presentation.name, style: const TextStyle(fontSize: 20))),
          ),
          if (currentSlideLocal != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onLongPress: () => setState(() {
                  setState(() {
                    _secondsPassed = 0;
                    _timer?.cancel();
                    _timePassedBySlide.clear();
                    _currentSlide = widget.presentation.slides.firstOrNull;
                  });
                }),
                onTap: () => setState(() {
                  if (_timer?.isActive != true) {
                    _createTimer();
                  } else if (!isLastSlideShown) {
                    _currentSlide = nextSlide;
                  } else {
                    _timer?.cancel();
                  }
                }),
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
                      _timer?.isActive != true
                          ? _secondsPassed == 0
                              ? "START"
                              : "RESUME"
                          : isLastSlideShown
                              ? "PAUSE"
                              : "NEXT SLIDE",
                      style: TextStyle(fontSize: 60, color: Colors.grey.withOpacity(0.2)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool get isLastSlideShown {
    final currentSlideLocal = _currentSlide;
    return currentSlideLocal != null && currentSlideLocal.id == widget.presentation.slides.lastOrNull?.id;
  }

  Slide? get nextSlide {
    final currentSlideLocal = _currentSlide;
    if (currentSlideLocal == null || isLastSlideShown) return null;
    return widget.presentation.slides[widget.presentation.slides.indexWhere((s) => s.id == currentSlideLocal.id) + 1];
  }

  int get timeOnCurrentSlide {
    final currentSlideLocal = _currentSlide;
    if (currentSlideLocal == null) return 0;
    return _timePassedBySlide[currentSlideLocal.id] ?? 0;
  }

  int get expectedTimeSpent {
    final currentSlideLocal = _currentSlide;
    if (currentSlideLocal == null) return 0;
    final timeBudgetForPreviousSlides = widget.presentation.slides
        .takeWhile((s) => s.id != currentSlideLocal.id)
        .fold<int>(0, (acc, s) => acc + s.duration.inSeconds);
    return min(timeOnCurrentSlide, currentSlideLocal.duration.inSeconds) + timeBudgetForPreviousSlides;
  }
}
