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
      {this.name = 'Unnamed Slide',
      this.duration = const Duration(seconds: 30),
      this.fromColor = Colors.white,
      this.toColor = Colors.grey})
      : id = _uuid.v4();

  Slide.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        duration = Duration(seconds: json['durationInSeconds']),
        fromColor = Color(json['fromColor']),
        toColor = Color(json['toColor']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'durationInSeconds': duration.inSeconds,
        'fromColor': fromColor.value,
        'toColor': toColor.value,
      };
}
