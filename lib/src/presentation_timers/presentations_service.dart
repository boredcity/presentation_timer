import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/presentation.dart';

class PresentationsService {
  Future<List<Presentation>> presentations() async {
    final prefs = await SharedPreferences.getInstance();
    final presentationsJSON = prefs.getString('presentations') ?? "[]";
    final presentations = List<Presentation>.from(jsonDecode(presentationsJSON).map((x) => Presentation.fromJson(x)));
    return presentations;
  }

  Future<void> updatePresentations(List<Presentation> presentations) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('presentations', jsonEncode(presentations.map((x) => x.toJson()).toList()));
  }
}
