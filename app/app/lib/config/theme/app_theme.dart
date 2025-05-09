import 'package:flutter/material.dart';

class AppTheme {
  ThemeData theme() {
    return ThemeData(
      primaryColor: const Color(0xFF0D47A1),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0D47A1),
         error: Colors.red
      ),
      scaffoldBackgroundColor: Colors.white,
    );
  }
}
