import 'package:flutter/material.dart';

class AppTheme {
  ThemeData theme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.white
      ),
      scaffoldBackgroundColor: Colors.white,
      tabBarTheme: TabBarTheme(
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: Color(0xFF38373C),
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
