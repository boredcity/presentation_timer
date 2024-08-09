import 'package:presentation_timer/src/presentation_timers/models/slide.dart';
import 'package:uuid/uuid.dart';

class Presentation {
  static const Uuid _uuid = Uuid();

  final String id;
  final String name;
  final List<Slide> slides;

  Duration get duration {
    if (slides.isEmpty) {
      return const Duration(seconds: 0);
    }
    final totalSlidesDurationInSeconds =
        slides.map((x) => x.duration.inSeconds).reduce((value, element) => value + element);
    return Duration(seconds: totalSlidesDurationInSeconds);
  }

  Presentation({id, this.name = 'Unnamed Presentation', this.slides = const []}) : id = id ?? _uuid.v4();

  Presentation.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        slides = List<Slide>.from(json['slides'].map((x) => Slide.fromJson(x)));

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slides': slides.map((x) => x.toJson()).toList(),
      };

  Presentation copyWith({
    String? id,
    String? name,
    List<Slide>? slides,
  }) {
    return Presentation(
      id: id ?? this.id,
      name: name ?? this.name,
      slides: slides ?? this.slides,
    );
  }
}
