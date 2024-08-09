import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  Future<ThemeMode> themeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeMode = prefs.getString('themeMode');
    return themeMode != null
        ? ThemeMode.values.firstWhere(
            (theme) => theme.toString() == themeMode,
            orElse: () => ThemeMode.system,
          )
        : ThemeMode.system;
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', theme.toString());
  }
}
