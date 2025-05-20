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
      tabBarTheme: TabBarTheme(
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: Color(0xFF212121),
          borderRadius: BorderRadius.circular(50),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        splashFactory: InkSplash.splashFactory,
        unselectedLabelColor: Colors.black
      )
    );
  }
}
