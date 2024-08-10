import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Slide {
  static const Uuid _uuid = Uuid();

  final String id;
  final String name;
  final Duration duration;
  final Color fromColor;
  final Color toColor;

  Slide(
      {String? id,
      this.name = 'Unnamed Slide',
      this.duration = const Duration(seconds: 30),
      this.fromColor = Colors.white,
      this.toColor = Colors.grey})
      : id = id ?? _uuid.v4();

  static Slide fromJson(Map<String, dynamic> json) => switch (json) {
        {
          'id': String id,
          'name': String name,
          'durationInSeconds': int durationInSeconds,
          'fromColor': int fromColor,
          'toColor': int toColor
        } =>
          Slide(
            id: id,
            name: name,
            duration: Duration(seconds: durationInSeconds),
            fromColor: Color(fromColor),
            toColor: Color(toColor),
          ),
        _ => throw ArgumentError.value(json, 'json', 'Invalid Slide JSON'),
      };

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'durationInSeconds': duration.inSeconds,
        'fromColor': fromColor.value,
        'toColor': toColor.value,
      };
}
