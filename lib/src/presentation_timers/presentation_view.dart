import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:presentation_timer/src/presentation_timers/models/presentation.dart';
import 'package:presentation_timer/src/presentation_timers/presentations_controller.dart';
import 'package:presentation_timer/src/presentation_timers/timer_slide.dart';
import 'package:presentation_timer/src/extensions/int.dart';

import 'models/slide.dart';
import 'pressable_bottom_section.dart';

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
  final PageController _pageController = PageController(initialPage: 0);

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
    final noSlides = widget.presentation.slides.isEmpty;
    final totalTimeLeft = widget.presentation.duration.inSeconds - _secondsPassed;

    final differenceWithExpectedTime = expectedTimeSpent - _secondsPassed;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          if (noSlides)
            const SizedBox.expand(child: Center(child: Text("No slides")))
          else
            PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: widget.presentation.slides.length,
              controller: _pageController,
              itemBuilder: (context, index) => index >= widget.presentation.slides.length
                  ? null
                  : Stack(
                      children: [
                        TimerSlide(
                          key: Key(widget.presentation.slides[index].id),
                          text: widget.presentation.slides[index].name,
                          duration: widget.presentation.slides[index].duration,
                          timePassed: _timePassedBySlide[widget.presentation.slides[index].id] ?? 0,
                          colorFrom: Colors.amber.withOpacity(index / 10),
                          colorTo: widget.presentation.slides[index].toColor,
                          isTimerActive: _timer?.isActive ?? false,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: PressableBottomSection(
                            text: _timer?.isActive == true
                                ? index == widget.presentation.slides.length - 1
                                    ? "PAUSE"
                                    : "NEXT SLIDE"
                                : _timePassedBySlide.isEmpty
                                    ? "START"
                                    : "RESUME",
                            onLongPress: () => setState(() {
                              setState(() {
                                _secondsPassed = 0;
                                _timer?.cancel();
                                _timePassedBySlide.clear();
                                _currentSlide = widget.presentation.slides.firstOrNull;
                              });
                              _pageController.animateToPage(0,
                                  duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                            }),
                            onTap: () => setState(() {
                              if (_timer?.isActive != true) {
                                _createTimer();
                              } else if (!isLastSlideShown) {
                                _currentSlide = nextSlide;
                                _pageController.animateToPage(_pageController.page!.toInt() + 1,
                                    duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                              } else {
                                _timer?.cancel();
                              }
                            }),
                          ),
                        ),
                      ],
                    ),
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 40),
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
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
              ),
            ),
          ),
          IgnorePointer(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: noSlides
                  ? Align(
                      alignment: Alignment.topCenter,
                      child: Text(widget.presentation.name, style: const TextStyle(fontSize: 20)),
                    )
                  : Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Text("Total time left: ${totalTimeLeft.getHumanReadableDuration()}",
                          style: const TextStyle(fontSize: 20)),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: AnimatedOpacity(
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
                        ),
                      )
                    ]),
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
