import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:medstock/core/theme/app_color.dart';
import 'package:medstock/core/theme/app_font.dart';
import 'package:medstock/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeState {
  final ThemeData themeData;
  final Map<String, Color> colors;
  final String font;

  AppThemeState({required this.themeData, required this.colors, required this.font});
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeState>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<AppThemeState> {
  String _currentFont = AppFonts.fonts[1];

  ThemeNotifier() : super(AppThemeState(
    themeData: AppTheme.fromTheme(AppColors.medStock, AppFonts.fonts[1]),
    colors: AppColors.medStock,
    font: AppFonts.fonts[1],
  )) {
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString('themeName') ?? 'MedStock';
    final fontName  = prefs.getString('fontName')  ?? AppFonts.fonts[1];

    final saved = AppColors.all.firstWhere(
      (t) => t['name'] == themeName,
      orElse: () => AppColors.all.first,
    );

    final colors = saved['colors'] as Map<String, Color>;
    _currentFont = fontName;
    state = AppThemeState(
      themeData: AppTheme.fromTheme(colors, _currentFont),
      colors: colors,
      font: _currentFont,
    );
  }

  Future<void> setTheme(Map<String, Color> colors, String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeName', themeName);
    state = AppThemeState(
      themeData: AppTheme.fromTheme(colors, _currentFont),
      colors: colors,
      font: _currentFont,
    );
  }

  Future<void> setFont(String fontFamily) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fontName', fontFamily);
    _currentFont = fontFamily;
    state = AppThemeState(
      themeData: AppTheme.fromTheme(state.colors, _currentFont),
      colors: state.colors,
      font: _currentFont,
    );
  }
}

// Providers derivados — se sincronizan solos
final colorsProvider = Provider<Map<String, Color>>((ref) {
  return ref.watch(themeProvider).colors;
});

final themeDataProvider = Provider<ThemeData>((ref) {
  return ref.watch(themeProvider).themeData;
});