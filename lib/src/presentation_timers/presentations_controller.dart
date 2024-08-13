import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/presentation.dart';
import 'presentations_service.dart';

class PresentationsController with ChangeNotifier {
  PresentationsController(this._presentationsService);

  static PresentationsController of(BuildContext context) => context.read<PresentationsController>();

  final PresentationsService _presentationsService;

  late List<Presentation> _presentations;

  List<Presentation> get presentations => _presentations;

  Future<void> loadPresentations() async {
    _presentations = await _presentationsService.presentations();
    notifyListeners();
  }

  Future<void> updatePresentation(Presentation updatedPresentation) async {
    _presentations = _presentations.map((x) => x.id == updatedPresentation.id ? updatedPresentation : x).toList();
    notifyListeners();
    await _presentationsService.updatePresentations(_presentations);
  }

  Future<void> removePresentation(String presentationId) async {
    _presentations = _presentations.where((x) => x.id != presentationId).toList();
    notifyListeners();
    await _presentationsService.updatePresentations(_presentations);
  }

  Future<void> createPresentation(Presentation newPresentation) async {
    _presentations.add(newPresentation);
    notifyListeners();
    await _presentationsService.updatePresentations(_presentations);
  }
}
