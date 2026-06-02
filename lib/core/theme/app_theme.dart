// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static ThemeData fromTheme(Map<String, Color> colors, String fontFamily) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: colors['primary']!,
      primary: colors['primary']!,
      secondary: colors['secondary']!,
    );
    final baseTextTheme = GoogleFonts.getTextTheme(fontFamily);

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,

      appBarTheme: AppBarTheme(
        backgroundColor: colors['drawerHeader'],
        foregroundColor: colors['textOnPrimary'],
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: colors['textOnPrimary'],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        ),
      ),

      cardTheme: CardThemeData(
        color: colors['cardBackground'],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colors['cardBorder']!, width: 1.5),
        ),
      ),

      // Drawer
      drawerTheme: DrawerThemeData(
        backgroundColor: colors['cardBackground'],
      ),

      // Textos sutiles

      textTheme: baseTextTheme.copyWith(
        bodyLarge:   baseTextTheme.bodyLarge?.copyWith(color: colors['textOnSurface']),
        bodyMedium:  baseTextTheme.bodyMedium?.copyWith(color: colors['textOnSurface']),
        bodySmall:   baseTextTheme.bodySmall?.copyWith(color: colors['textSubtle']),
        titleLarge:  baseTextTheme.titleLarge?.copyWith(color: colors['textOnSurface']),
        titleMedium: baseTextTheme.titleMedium?.copyWith(color: colors['textOnSurface']),
        titleSmall:  baseTextTheme.titleSmall?.copyWith(color: colors['textOnSurface']),
        labelLarge:  baseTextTheme.labelLarge?.copyWith(color: colors['textOnSurface']),
      ),

      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: colors['textSubtle']),
        hintStyle:  TextStyle(color: colors['textSubtle']),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),

      scaffoldBackgroundColor: colors['cardBackground'],

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors['primary'],
      ),

      iconTheme: IconThemeData(
        color: colors['iconPrimary'],
      ),

      listTileTheme: ListTileThemeData(
        iconColor: colors['iconPrimary'],
        textColor: colors['textOnSurface'],
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: colors['cardBackground'],
        titleTextStyle: TextStyle(
          color: colors['textOnSurface'],
        ),
        contentTextStyle: TextStyle(color: colors['textOnSurface']),
      ),

      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: TextStyle(color: colors['textOnSurface']),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(colors['cardBackground']),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          side: WidgetStateProperty.all(
            BorderSide(color: colors['cardBorder']!, width: 1.5),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: colors['textOnSurface']),
          hintStyle:  TextStyle(color: colors['textOnSurface']),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: colors['priceBackground'],
      ),
    );
  }
}